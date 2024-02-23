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
    
    public init() {
        super.init(frame: .zero, style: .insetGrouped)
        commonInit()
    }
    
    public init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        commonInit()
    }
    
    private func commonInit() {
        delaysContentTouches = false
        cellLayoutMarginsFollowReadableWidth = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
