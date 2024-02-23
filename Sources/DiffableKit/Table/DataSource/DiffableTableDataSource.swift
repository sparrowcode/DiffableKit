import UIKit

@available(iOS 13.0, tvOS 13, *)
open class DiffableTableDataSource: NSObject, DiffableDataSourceInterface {
    
    open weak var diffableDelegate: DiffableTableDelegate?
    
    internal var headerFooterProviders: [HeaderFooterProvider]
    private var appleDiffableDataSource: AppleTableDiffableDataSource?
    private weak var tableView: UITableView?
    
    // MARK: - Init
    
    public init(
        tableView: UITableView,
        cellProviders: [CellProvider],
        headerFooterProviders: [HeaderFooterProvider]
    ) {
        
        // Table doesn't have `supplementaryViewProvider`. Did it manually.
        self.headerFooterProviders = headerFooterProviders
        
        super.init()
        
        self.appleDiffableDataSource = .init(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                for provider in cellProviders {
                    if let cell = provider.clouser(tableView, indexPath, item) {
                        return cell
                    }
                }
                return nil
            }
        )
        
        self.tableView = tableView
        self.tableView?.delegate = self
    }
    
    // MARK: - DiffableDataSourceInterface
    
    public func updateLayout(animated: Bool, completion: (() -> Void)? = nil) {
        guard let snapshot = appleDiffableDataSource?.snapshot() else { return }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    // MARK: Set
    
    public func set(_ sections: [DiffableSection], animated: Bool, completion: (() -> Void)? = nil) {
        
        let convertToSnapshot: ((_ sections: [DiffableSection]) -> AppleTableDiffableDataSource.Snapshot) = { sections in
            var snapshot = AppleTableDiffableDataSource.Snapshot()
            snapshot.appendSections(sections)
            for section in sections {
                snapshot.appendItems(section.items, toSection: section)
            }
            return snapshot
        }
        
        // 1. Add, remove & reoder
        
        let newSnaphsot = convertToSnapshot(sections)
        appleDiffableDataSource?.apply(newSnaphsot, animatingDifferences: animated, completion: completion)
        
        // 2. Update visible cells
        
        var items: [DiffableItem] = []
        for indexPath in self.tableView?.indexPathsForVisibleRows ?? [] {
            if let item = getItem(indexPath: indexPath) {
                items.append(item)
            }
        }
        
        if !items.isEmpty {
            reconfigure(items)
        }
    }
    
    public func reconfigureVisibleItems() {
        let visibleIndexPaths = tableView?.indexPathsForVisibleRows ?? []
        var visibleItems: [DiffableItem] = []
        for indexPath in visibleIndexPaths {
            if let item = getItem(indexPath: indexPath) {
                visibleItems.append(item)
            }
        }
        reconfigure(visibleItems)
    }
    
    public func reconfigure(_ items: [DiffableItem]) {
        guard var snapshot = appleDiffableDataSource?.snapshot() else { return }
        if #available(iOS 15.0, tvOS 15, *) {
            snapshot.reconfigureItems(items)
        } else {
            snapshot.reloadItems(items)
        }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: Get
    
    public func getItem(id: String) -> DiffableItem? {
        let snapshot = appleDiffableDataSource?.snapshot()
        return snapshot?.itemIdentifiers.first(where: { $0.id == id })
    }
    
    public func getItem(indexPath: IndexPath) -> DiffableItem? {
        return appleDiffableDataSource?.itemIdentifier(for: indexPath)
    }
    
    public func getSection(id: String) -> DiffableSection? {
        return appleDiffableDataSource?.snapshot().sectionIdentifiers.first(where: { $0.id == id })
    }
    
    public func getSection(index: Int) -> DiffableSection? {
        if #available(iOS 15.0, *) {
            return appleDiffableDataSource?.sectionIdentifier(for: index)
        } else {
            guard let snapshot = appleDiffableDataSource?.snapshot() else { return nil }
            guard index < snapshot.sectionIdentifiers.count else { return nil }
            return snapshot.sectionIdentifiers[index]
        }
    }
    
    public func getIndexPath(id: String) -> IndexPath? {
        guard let item = getItem(id: id) else { return nil }
        return appleDiffableDataSource?.indexPath(for: item)
    }
    
    public func getIndexPath(item: DiffableItem) -> IndexPath? {
        return appleDiffableDataSource?.indexPath(for: item)
    }
}
