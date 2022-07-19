import UIKit

open class DiffableSection: NSObject {
    
    open var id: String
    
    open var header: DiffableItem?
    open var footer: DiffableItem?
    open var items: [DiffableItem]
    
    // MARK: - Init
    
    public init(
        id: String,
        header: DiffableItem? = nil,
        footer: DiffableItem? = nil,
        items: [DiffableItem] = []
    ) {
        self.id = id
        self.header = header
        self.footer = footer
        self.items = items
    }
}
