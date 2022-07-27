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
    
    // MARK: - Hashable and Equatable
    
    open override var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? DiffableSection else { return false }
        return id == object.id
    }
}
