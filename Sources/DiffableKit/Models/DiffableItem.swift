import UIKit

open class DiffableItem: NSObject {

    public let id: String

    public init(id: String) {
        self.id = id
    }

    // MARK: - Hashable & Equatable

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
