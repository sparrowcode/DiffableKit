import UIKit

/* Data source списка на `UICollectionView` с `DiffableListLayout`. Модели те же, что у таблицы
 (`DiffableSection`, `DiffableTableRow` и остальные из Table/Models), поэтому экран переезжает
 с таблицы на список сменой базового класса и провайдеров ячеек. */
@MainActor
open class DiffableListDataSource: NSObject, DiffableDataSourceInterface {

    open weak var diffableDelegate: DiffableListDelegate?

    internal weak var collectionView: UICollectionView?
    internal var headerFooterProviders: [HeaderFooterProvider]

    private var appleDiffableDataSource: UICollectionViewDiffableDataSource<String, String>?
    private var itemStore: [String: DiffableItem] = [:]
    private var sectionStore: [String: DiffableSection] = [:]

    // MARK: - Init

    /* `collectionView` должен быть на `DiffableListLayout`: лейаут спрашивает у data source,
     есть ли у секции заголовок и футер, а у делегата — свайпы. */
    public init(
        collectionView: UICollectionView,
        cellProviders: [CellProvider],
        headerFooterProviders: [HeaderFooterProvider] = []
    ) {
        self.collectionView = collectionView
        self.headerFooterProviders = headerFooterProviders

        super.init()

        let textHeaderRegistration = makeTextHeaderFooterRegistration(elementKind: UICollectionView.elementKindSectionHeader)
        let textFooterRegistration = makeTextHeaderFooterRegistration(elementKind: UICollectionView.elementKindSectionFooter)
        let listHeaderRegistration = UICollectionView.SupplementaryRegistration<DiffableListHeaderContainerView>(
            elementKind: DiffableListLayout.elementKindListHeader
        ) { _, _, _ in }

        let appleDiffableDataSource = UICollectionViewDiffableDataSource<String, String>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemID in
                guard let self else {
                    fatalError("DiffableListDataSource was deallocated while cellProvider is still active")
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
            }
        )
        appleDiffableDataSource.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            if elementKind == DiffableListLayout.elementKindListHeader {
                let view = collectionView.dequeueConfiguredReusableSupplementary(using: listHeaderRegistration, for: indexPath)
                view.hostedView = collectionView.collectionViewLayout.diffableListLayout?.headerView
                return view
            }
            guard let self, let section = self.getSection(index: indexPath.section) else { return nil }
            let item: DiffableItem?
            switch elementKind {
            case UICollectionView.elementKindSectionHeader: item = section.header
            case UICollectionView.elementKindSectionFooter: item = section.footer
            default: item = nil
            }
            guard let item else { return nil }
            for provider in self.headerFooterProviders {
                if let view = provider.closure(collectionView, elementKind, indexPath, item) {
                    return view
                }
            }
            guard item is DiffableTextHeaderFooter else { return nil }
            let registration = elementKind == UICollectionView.elementKindSectionHeader ? textHeaderRegistration : textFooterRegistration
            return collectionView.dequeueConfiguredReusableSupplementary(using: registration, for: indexPath)
        }
        self.appleDiffableDataSource = appleDiffableDataSource

        collectionView.collectionViewLayout.diffableListLayout?.context.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Set

    /* Применяет новое состояние секций и элементов. Как у `DiffableTableDataSource`: снапшот
     на String ID, объекты в itemStore/sectionStore, выжившие элементы переконфигурируются.
     Хранилище чистится только в completion, пока apply-анимация может спросить старые id.
     Заголовки и футеры `reconfigureItems` не трогает, поэтому видимые тексты обновляются отдельно.
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
        updateVisibleTextHeaderFooters()
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

    // MARK: - Swipes

    func leadingSwipeActionsConfiguration(at indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let collectionView, let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableListView?(collectionView, leadingSwipeActionsConfigurationForItem: item, at: indexPath)
    }

    func trailingSwipeActionsConfiguration(at indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let collectionView, let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableListView?(collectionView, trailingSwipeActionsConfigurationForItem: item, at: indexPath)
    }

    // MARK: - Header & Footer

    /* Текстовые заголовок и футер — системная `UICollectionViewListCell`: её
     `defaultContentConfiguration()` в заголовке и футере секции списка даёт их системный стиль
     на любой версии iOS (готовые `.header()` и `.footer()` есть только с iOS 18). */
    private func makeTextHeaderFooterRegistration(elementKind: String) -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: elementKind) { [weak self] view, kind, indexPath in
            self?.configureTextHeaderFooter(view, kind: kind, section: indexPath.section)
        }
    }

    private func configureTextHeaderFooter(_ view: UICollectionViewListCell, kind: String, section index: Int) {
        guard let section = getSection(index: index) else { return }
        let item = kind == UICollectionView.elementKindSectionHeader ? section.header : section.footer
        var content = view.defaultContentConfiguration()
        content.text = (item as? DiffableTextHeaderFooter)?.text
        view.contentConfiguration = content
    }

    private func updateVisibleTextHeaderFooters() {
        guard let collectionView else { return }
        for kind in [UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter] {
            for indexPath in collectionView.indexPathsForVisibleSupplementaryElements(ofKind: kind) {
                guard let view = collectionView.supplementaryView(forElementKind: kind, at: indexPath) as? UICollectionViewListCell else { continue }
                configureTextHeaderFooter(view, kind: kind, section: indexPath.section)
            }
        }
    }

    // MARK: - Private

    /* Накатывает новые items/sections поверх существующего хранилища без удаления.
     Старые id остаются, пока активная apply-анимация может их запросить через cellProvider. */
    private func mergeStores(from sections: [DiffableSection]) {
        for section in sections {
            sectionStore[section.id] = section
            for item in section.items {
                itemStore[item.id] = item
            }
        }
    }

    /* Вызывается из completion apply: удаляем из хранилища всё, чего нет в актуальном снапшоте. */
    private func cleanupStoresAfterApply() {
        guard let snapshot = appleDiffableDataSource?.snapshot() else { return }
        let validItems = Set(snapshot.itemIdentifiers)
        let validSections = Set(snapshot.sectionIdentifiers)
        itemStore = itemStore.filter { validItems.contains($0.key) }
        sectionStore = sectionStore.filter { validSections.contains($0.key) }
    }

    private func convertToSnapshot(_ sections: [DiffableSection]) -> NSDiffableDataSourceSnapshot<String, String> {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(sections.map { $0.id })
        for section in sections {
            snapshot.appendItems(section.items.map { $0.id }, toSection: section.id)
        }
        return snapshot
    }
}

// MARK: - Layout

extension UICollectionViewLayout {

    @MainActor
    var diffableListLayout: DiffableListLayout? { self as? DiffableListLayout }
}
