import UIKit

open class DiffableTableRowButton: DiffableItem {

    open var text: String
    open var detail: String?
    open var icon: UIImage?
    open var accessoryType: UITableViewCell.AccessoryType
    open var action: Action

    public init(
        id: String? = nil,
        text: String,
        detail: String? = nil,
        icon: UIImage? = nil,
        accessoryType: UITableViewCell.AccessoryType = .none,
        action: @escaping Action
    ) {
        self.text = text
        self.detail = detail
        self.icon = icon
        self.accessoryType = accessoryType
        self.action = action
        super.init(id: id ?? text)
    }

    public typealias Action = @MainActor (_ indexPath: IndexPath) -> Void
}
