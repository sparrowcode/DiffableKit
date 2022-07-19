import UIKit

class AppleTableDiffableDataSource: UITableViewDiffableDataSource<DiffableSection, DiffableItem> {
    
    // MARK: - Init
    
    override init(
        tableView: UITableView,
        cellProvider: @escaping CellProvider
    ) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    // MARK: - Wrappers
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<DiffableSection, DiffableItem>
}
