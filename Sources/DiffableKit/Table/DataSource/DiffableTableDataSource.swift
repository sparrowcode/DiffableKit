import UIKit

open class DiffableTableDataSource: NSObject, DiffableDataSourceInterface {

    open weak var diffableDelegate: DiffableTableDelegate? {
        didSet { appleDiffableDataSource?.diffableDelegate = diffableDelegate }
    }

    internal weak var tableView: UITableView?
    internal var headerFooterProviders: [HeaderFooterProvider]

    private var appleDiffableDataSource: AppleTableDiffableDataSource?
    private var itemStore: [String: DiffableItem] = [:]
    private var sectionStore: [String: DiffableSection] = [:]

    // MARK: - Init

    public init(
        tableView: UITableView,
        cellProviders: [CellProvider],
        headerFooterProviders: [HeaderFooterProvider] = []
    ) {
        self.tableView = tableView
        self.headerFooterProviders = headerFooterProviders

        super.init()

        self.appleDiffableDataSource = .init(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, itemID in
                guard let self else {
                    fatalError("DiffableTableDataSource was deallocated while cellProvider is still active")
                }
                guard let item = self.itemStore[itemID] else {
                    fatalError("No DiffableItem in store for id: \(itemID)")
                }
                for provider in cellProviders {
                    if let cell = provider.closure(tableView, indexPath, item) {
                        return cell
                    }
                }
                fatalError("No CellProvider returned a cell for item: \(type(of: item)) (id: \(item.id))")
            }
        )

        self.appleDiffableDataSource?.sectionForID = { [weak self] sectionID in
            self?.sectionStore[sectionID]
        }

        self.tableView?.delegate = self
    }

    // MARK: - Set

    /* Применяет новое состояние секций и элементов. Diffable data source вычисляет разницу
     между текущим и новым снапшотом и анимирует структурные изменения (вставки, удаления, перемещения).
     Снапшот использует String ID как идентификаторы (value type), а объекты хранятся в itemStore/sectionStore.
     Surviving items автоматически reconfigure — cellProvider вызывается заново с обновлёнными данными из store.
     https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource/apply(_:animatingdifferences:completion:) */
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

    /* Переприменяет текущий снапшот без изменений — пересчитывает layout (высоты ячеек, отступы). */
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
            for item in section.items {
                newItemStore[item.id] = item
            }
        }
        itemStore = newItemStore
        sectionStore = newSectionStore
    }

    private func convertToSnapshot(_ sections: [DiffableSection]) -> AppleTableDiffableDataSource.Snapshot {
        var snapshot = AppleTableDiffableDataSource.Snapshot()
        snapshot.appendSections(sections.map { $0.id })
        for section in sections {
            snapshot.appendItems(section.items.map { $0.id }, toSection: section.id)
        }
        return snapshot
    }
}
