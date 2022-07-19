import UIKit

open class DiffableActionableItem: DiffableItem {
    
    open var action: Action?
    
    public init(id: String, action: Action? = nil) {
        self.action = action
        super.init(id: id)
    }
    
    public typealias Action = (_ item: DiffableItem, _ indexPath: IndexPath) -> Void
}
