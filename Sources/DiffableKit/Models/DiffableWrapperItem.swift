import UIKit

open class DiffableWrapperItem: DiffableActionableItem {
    
    open var model: Any
    
    public init(id: String, model: Any, action: Action? = nil) {
        self.model = model
        super.init(id: id, action: action)
    }
}

