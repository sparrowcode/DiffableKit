import UIKit

open class DiffableTableRowSubtitle: DiffableActionableItem {
    
    open var text: String
    open var subtitle: String? = nil
    open var icon: UIImage? = nil
    open var selectionStyle: UITableViewCell.SelectionStyle
    open var accessoryType: UITableViewCell.AccessoryType
    
    public init(
        id: String? = nil,
        text: String,
        subtitle: String?,
        icon: UIImage? = nil,
        accessoryType: UITableViewCell.AccessoryType = .none,
        selectionStyle: UITableViewCell.SelectionStyle = .none,
        action: Action? = nil
    ) {
        self.text = text
        self.subtitle = subtitle
        self.icon = icon
        self.accessoryType = accessoryType
        self.selectionStyle = selectionStyle
        super.init(id: id ?? text, action: action)
    }
}
