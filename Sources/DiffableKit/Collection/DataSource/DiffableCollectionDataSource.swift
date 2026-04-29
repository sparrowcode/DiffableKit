import UIKit

@MainActor
open class DiffableCollectionDataSource: NSObject, DiffableDataSourceInterface {

    open weak var diffableDelegate: DiffableCollectionDelegate?

    internal weak var collectionView: UICollectionView?

    private var appleDiffableDataSource: AppleCollectionDiffableDataSource?
    private var itemStore: [String: DiffableItem] = [:]
    private var sectionStore: [String: DiffableSection] = [:]

    // MARK: - Init

    public init(
        collectionView: UICollectionView,
        cellProviders: [CellProvider],
        headerFooterProviders: [HeaderFooterProvider] = []
    ) {
        self.collectionView = collectionView

        super.init()

        self.appleDiffableDataSource = .init(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemID in
                guard let self else {
                    fatalError("DiffableCollectionDataSource was deallocated while cellProvider is still active")
                }
                guard let item = self.itemStore[itemID] else {
                    fatalError("No DiffableItem in store for id: \(itemID)")
                }
                for provider in cellProviders {
                    if let cell = provider.closure(collectionView, indexPath, item) {
                        return cell
                    }
                }
                fatalError("No CellProvider returned a cell for item: \(type(of: item)) (id: \(item.id))")
            },
            headerFooterProvider: { [weak self] collectionView, elementKind, indexPath in
                guard let self else { return nil }
                guard let section = self.getSection(index: indexPath.section) else { return nil }

                for provider in headerFooterProviders {
                    switch elementKind {
                    case UICollectionView.elementKindSectionHeader:
                        guard let headerItem = section.header else { continue }
                        if let view = provider.closure(collectionView, elementKind, indexPath, headerItem) {
                            return view
                        }
                    case UICollectionView.elementKindSectionFooter:
                        guard let footerItem = section.footer else { continue }
                        if let view = provider.closure(collectionView, elementKind, indexPath, footerItem) {
                            return view
                        }
                    default:
                        return nil
                    }
                }
                return nil
            }
        )

        self.collectionView?.delegate = self
    }

    // MARK: - Set

    /* Применяет новое состояние секций и элементов. Diffable data source вычисляет разницу
     между текущим и новым снапшотом и анимирует структурные изменения (вставки, удаления, перемещения).
     Снапшот использует String ID как идентификаторы (value type), а объекты хранятся в itemStore/sectionStore.
     Surviving items автоматически reconfigure — cellProvider вызывается заново с обновлёнными данными из store.

     Жизненный цикл хранилища: пока идёт apply-анимация, UICollectionView легитимно дёргает cellProvider
     для self-sizing и предварительных измерений по обоим наборам id (старым и новым). Чтобы cellProvider
     всегда находил DiffableItem, накатываем новые items оверлеем поверх старых перед apply, а удаляем
     лишние только в completion — после того как Apple завершил применение и анимации.
     https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/apply(_:animatingdifferences:completion:) */
    public func set(_ sections: [DiffableSection], animated: Bool, completion: (() -> Void)? = nil) {
        mergeStores(from: sections)
        var snapshot = convertToSnapshot(sections)
        if let currentIDs = appleDiffableDataSource?.snapshot().itemIdentifiers {
            let currentSet = Set(currentIDs)
            let toReconfigure = snapshot.itemIdentifiers.filter { currentSet.contains($0) }
            if !toReconfigure.isEmpty {
                snapshot.reconfigureItems(toReconfigure)
            }
        }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: animated) { [weak self] in
            self?.cleanupStoresAfterApply()
            completion?()
        }

        for section in sections {
            guard let collectionSection = section as? DiffableCollectionSection else { continue }

            var sectionSnapshot = AppleCollectionDiffableDataSource.SectionSnapshot()

            if collectionSection.headerAsFirstCell, let header = section.header {
                sectionSnapshot.append([header.id])
                sectionSnapshot.append(section.items.map { $0.id }, to: header.id)
            } else {
                sectionSnapshot.append(section.items.map { $0.id })
            }

            if collectionSection.expanded {
                sectionSnapshot.expand(sectionSnapshot.items)
            } else {
                sectionSnapshot.collapse(sectionSnapshot.items)
            }

            appleDiffableDataSource?.apply(sectionSnapshot, to: section.id, animatingDifferences: animated)
        }
    }

    /* Обновляет содержимое ячеек без пересоздания — переиспользует существующие ячейки.
     Вызывай отдельно от структурных изменений — нельзя смешивать с удалениями/вставками в одном apply.
     https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot/reconfigureitems(_:) */
    public func reconfigure(_ items: [DiffableItem], animated: Bool = false) {
        guard var snapshot = appleDiffableDataSource?.snapshot() else { return }
        let existingIDs = Set(snapshot.itemIdentifiers)
        let validItems = items.filter { existingIDs.contains($0.id) }
        guard !validItems.isEmpty else { return }
        for item in validItems {
            itemStore[item.id] = item
        }
        snapshot.reconfigureItems(validItems.map { $0.id })
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: animated)
    }

    /* Переприменяет текущий снапшот без изменений — пересчитывает layout (размеры ячеек, отступы). */
    public func updateLayout(animated: Bool, completion: (() -> Void)? = nil) {
        guard let snapshot = appleDiffableDataSource?.snapshot() else { return }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: animated, completion: completion)
    }

    // MARK: - Get

    public func getItem(id: String) -> DiffableItem? {
        return itemStore[id]
    }

    public func getItem(indexPath: IndexPath) -> DiffableItem? {
        guard let itemID = appleDiffableDataSource?.itemIdentifier(for: indexPath) else { return nil }
        return itemStore[itemID]
    }

    public func getSection(id: String) -> DiffableSection? {
        return sectionStore[id]
    }

    public func getSection(index: Int) -> DiffableSection? {
        guard let snapshot = appleDiffableDataSource?.snapshot() else { return nil }
        guard index < snapshot.sectionIdentifiers.count else { return nil }
        return sectionStore[snapshot.sectionIdentifiers[index]]
    }

    public func getIndexPath(id: String) -> IndexPath? {
        return appleDiffableDataSource?.indexPath(for: id)
    }

    public func getIndexPath(item: DiffableItem) -> IndexPath? {
        return appleDiffableDataSource?.indexPath(for: item.id)
    }

    // MARK: - Private

    /* Накатывает новые items/sections поверх существующего хранилища без удаления.
     Старые id остаются, пока активная apply-анимация может их запросить через cellProvider. */
    private func mergeStores(from sections: [DiffableSection]) {
        for section in sections {
            sectionStore[section.id] = section
            if let collectionSection = section as? DiffableCollectionSection,
               collectionSection.headerAsFirstCell, let header = section.header {
                itemStore[header.id] = header
            }
            for item in section.items {
                itemStore[item.id] = item
            }
        }
    }

    /* Вызывается из completion apply: к этому моменту UICollectionView завершил применение нового
     снапшота и больше не запросит cellProvider по старым id. Удаляем из хранилища всё, чего нет
     в актуальных снапшотах Apple data source — учитываем и основной снапшот, и section snapshots
     (DiffableCollectionSection хранит свои items в section snapshot, а не в основном). */
    private func cleanupStoresAfterApply() {
        guard let mainSnapshot = appleDiffableDataSource?.snapshot() else { return }
        var validItems = Set(mainSnapshot.itemIdentifiers)
        let validSections = Set(mainSnapshot.sectionIdentifiers)
        for sectionID in validSections {
            if let sectionSnapshot = appleDiffableDataSource?.snapshot(for: sectionID) {
                validItems.formUnion(sectionSnapshot.items)
            }
        }
        itemStore = itemStore.filter { validItems.contains($0.key) }
        sectionStore = sectionStore.filter { validSections.contains($0.key) }
    }

    private func convertToSnapshot(_ sections: [DiffableSection]) -> AppleCollectionDiffableDataSource.Snapshot {
        var snapshot = AppleCollectionDiffableDataSource.Snapshot()
        snapshot.appendSections(sections.map { $0.id })
        for section in sections {
            /* DiffableCollectionSection получает items через section snapshot —
             добавлять их в main snapshot не нужно, иначе будет двойной apply. */
            if section is DiffableCollectionSection { continue }
            snapshot.appendItems(section.items.map { $0.id }, toSection: section.id)
        }
        return snapshot
    }
}
