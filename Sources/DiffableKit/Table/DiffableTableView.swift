import UIKit

open class DiffableTableView: UITableView {

    open var diffableDataSource: DiffableTableDataSource?

    // MARK: - Init

    public init(style: UITableView.Style = .insetGrouped) {
        super.init(frame: .zero, style: style)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        delaysContentTouches = false
        cellLayoutMarginsFollowReadableWidth = true
        register(DiffableTableViewCell.self, forCellReuseIdentifier: DiffableTableViewCell.reuseIdentifier)
        register(DiffableSubtitleTableViewCell.self, forCellReuseIdentifier: DiffableSubtitleTableViewCell.reuseIdentifier)
        register(DiffableButtonTableViewCell.self, forCellReuseIdentifier: DiffableButtonTableViewCell.reuseIdentifier)
    }

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
