import UIKit

open class DiffableTableController: UITableViewController {

    open var diffableDataSource: DiffableTableDataSource?

    // MARK: - Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delaysContentTouches = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(DiffableTableViewCell.self, forCellReuseIdentifier: DiffableTableViewCell.reuseIdentifier)
        tableView.register(DiffableSubtitleTableViewCell.self, forCellReuseIdentifier: DiffableSubtitleTableViewCell.reuseIdentifier)
        tableView.register(DiffableButtonTableViewCell.self, forCellReuseIdentifier: DiffableButtonTableViewCell.reuseIdentifier)
    }

    // MARK: - Configure

    open func configureDiffable(
        sections: [DiffableSection],
        cellProviders: [DiffableTableDataSource.CellProvider],
        headerFooterProviders: [DiffableTableDataSource.HeaderFooterProvider] = []
    ) {
        diffableDataSource = DiffableTableDataSource(
            tableView: tableView,
            cellProviders: cellProviders,
            headerFooterProviders: headerFooterProviders
        )
        diffableDataSource?.set(sections, animated: false)
    }
}
