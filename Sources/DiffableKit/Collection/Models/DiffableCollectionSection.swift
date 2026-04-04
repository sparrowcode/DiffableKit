import UIKit

open class DiffableCollectionSection: DiffableSection {

    open var headerAsFirstCell: Bool
    open var expanded: Bool

    public init(
        id: String,
        header: DiffableItem? = nil,
        headerAsFirstCell: Bool = false,
        footer: DiffableItem? = nil,
        items: [DiffableItem] = [],
        expanded: Bool = true
    ) {
        self.headerAsFirstCell = headerAsFirstCell
        self.expanded = expanded
        super.init(id: id, header: header, footer: footer, items: items)
    }
}
