import UIKit

class NativeTableRowModel: DiffableItem {
    
    var text: String
    var selectionStyle: UITableViewCell.SelectionStyle
    var detail: String? = nil
    var accessoryType: UITableViewCell.AccessoryType
    var action: Action?
    
    init(text: String, detail: String?, accessoryType: UITableViewCell.AccessoryType, selectionStyle: UITableViewCell.SelectionStyle, action: Action?) {
        self.text = text
        self.detail = detail
        self.accessoryType = accessoryType
        self.selectionStyle = selectionStyle
        self.action = action
        super.init(text)
    }
    
    typealias Action = (_ indexPath: IndexPath) -> Void
}
