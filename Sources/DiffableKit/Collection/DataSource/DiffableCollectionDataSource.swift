import UIKit

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
     https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/apply(_:animatingdifferences:completion:) */
    public func set(_ sections: [DiffableSection], animated: Bool, completion: (() -> Void)? = nil) {
        rebuildStores(from: sections)
        var snapshot = convertToSnapshot(sections)
        if let currentIDs = appleDiffableDataSource?.snapshot().itemIdentifiers {
            let currentSet = Set(currentIDs)
            let toReconfigure = snapshot.itemIdentifiers.filter { currentSet.contains($0) }
            if !toReconfigure.isEmpty {
                snapshot.reconfigureItems(toReconfigure)
            }
        }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: animated, completion: completion)

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

    private func rebuildStores(from sections: [DiffableSection]) {
        var newItemStore: [String: DiffableItem] = [:]
        var newSectionStore: [String: DiffableSection] = [:]
        for section in sections {
            newSectionStore[section.id] = section
            if let collectionSection = section as? DiffableCollectionSection,
               collectionSection.headerAsFirstCell, let header = section.header {
                newItemStore[header.id] = header
            }
            for item in section.items {
                newItemStore[item.id] = item
            }
        }
        itemStore = newItemStore
        sectionStore = newSectionStore
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
