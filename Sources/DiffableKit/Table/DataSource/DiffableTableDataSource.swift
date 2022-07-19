import UIKit

open class DiffableTableDataSource: NSObject, DiffableDataSourceInterface {
    
    open weak var diffableDelegate: DiffableTableDelegate?
    internal var headerFooterProviders: [HeaderFooterProvider]
    private var appleDiffableDataSource: AppleTableDiffableDataSource?
    
    // MARK: - Init
    
    init(
        tableView: UITableView,
        cellProviders: [CellProvider],
        headerFooterProviders: [HeaderFooterProvider]
    ) {
        
        // Table doesn't have `supplementaryViewProvider`.
        // Did it manually.
        self.headerFooterProviders = headerFooterProviders
        
        super.init()
        
        self.appleDiffableDataSource = .init(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                for provider in cellProviders {
                    guard let item = self.getItem(id: itemIdentifier.id) else { continue }
                    if let cell = provider.clouser(tableView, indexPath, item) {
                        return cell
                    }
                }
                return nil
            }
        )
        
        tableView.delegate = self
    }
    
    // MARK: - DiffableDataSourceInterface
    
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
        
        // Add, remove or reoder
        
        let snapshot = convertToSnapshot(sections)
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: animated, completion: completion)
        
        // Update visible cells
        // Droped logic for now.
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
