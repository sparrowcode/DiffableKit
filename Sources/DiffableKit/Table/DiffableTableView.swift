import UIKit

open class DiffableTableView: UITableView {
    
    open var diffableDataSource: DiffableTableDataSource?
    
    // MARK: - Configure
    
    open func configureDiffable(
        sections: [DiffableSection],
        cellProviders: [DiffableTableDataSource.CellProvider],
        headerFooterProviders: [DiffableTableDataSource.HeaderFooterProvider] = []
    ) {
        diffableDataSource = DiffableTableDataSource(
            tableView: self,
            cellProviders: cellProviders,
            headerFooterProviders: headerFooterProviders
        )
        diffableDataSource?.set(sections, animated: false)
    }
}
