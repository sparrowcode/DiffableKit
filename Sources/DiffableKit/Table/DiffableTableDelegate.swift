import UIKit

@objc public protocol DiffableTableDelegate: AnyObject {

    @objc optional func diffableTableView(_ tableView: UITableView, didSelectItem item: DiffableItem, indexPath: IndexPath)

    @objc optional func diffableTableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForItem item: DiffableItem, at indexPath: IndexPath) -> UISwipeActionsConfiguration?

    @objc optional func diffableTableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForItem item: DiffableItem, at indexPath: IndexPath) -> UISwipeActionsConfiguration?

    @objc optional func diffableTableView(_ tableView: UITableView, contextMenuConfigurationForItem item: DiffableItem, at indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
}
