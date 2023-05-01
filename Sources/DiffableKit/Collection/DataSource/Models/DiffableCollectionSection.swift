import UIKit

open class DiffableCollectionSection: DiffableSection {
    
    open var headerProcess: DiffableCollectinoDataSourceHeaderProcessWay
    open var expanded: Bool
    
    // MARK: - Init
    
    public init(
        id: String,
        header: DiffableItem? = nil,
        headerProcess: DiffableCollectinoDataSourceHeaderProcessWay,
        footer: DiffableItem? = nil,
        items: [DiffableItem] = [],
        expanded: Bool = true
    ) {
        self.headerProcess = headerProcess
        self.expanded = expanded
        super.init(id: id, header: header, footer: footer, items: items)
    }
}
