import UIKit

@objc public protocol DiffableTableDelegate: AnyObject {
    
    @objc optional func diffableTableView(_ tableView: UITableView, didSelectItem item: DiffableItem, indexPath: IndexPath)
    
    @objc optional func diffableTableView(_ tableView: UITableView, shouldIndentWhileEditingItem item: DiffableItem, indexPath: IndexPath) -> Bool
    
    @objc optional func diffableTableView(_ tableView: UITableView, editingStyleForItem item: DiffableItem, indexPath: IndexPath) -> UITableViewCell.EditingStyle
    
    #if canImport(UIKit) && (os(iOS))
    @objc optional func diffableTableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForItem item: DiffableItem, at indexPath: IndexPath) -> UISwipeActionsConfiguration?

    @objc optional func diffableTableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForItem item: DiffableItem, at indexPath: IndexPath) -> UISwipeActionsConfiguration?
    #endif
}
