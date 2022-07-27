import UIKit

open class DiffableTableRowSwitch: DiffableItem {
    
    open var text: String
    open var icon: UIImage?
    open var isOn: Bool
    open var action: Action
    
    public init(
        id: String? = nil,
        text: String,
        icon: UIImage? = nil,
        isOn: Bool,
        action: @escaping Action
    ) {
        self.text = text
        self.icon = icon
        self.isOn = isOn
        self.action = action
        super.init(id: id ?? text)
    }
    
    public typealias Action = (_ item: DiffableItem, _ indexPath: IndexPath, _ state: Bool) -> Void
}
