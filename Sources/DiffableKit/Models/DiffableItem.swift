import UIKit

open class DiffableItem: NSObject {
    
    open var id: String
    
    // MARK: - Init
    
    public init(id: String) {
        self.id = id
    }
    
    // MARK: - Hashable and Equatable
    
    open override var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? DiffableItem else { return false }
        return id == object.id
    }
}
