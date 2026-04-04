import UIKit

extension DiffableTableDataSource: UITableViewDelegate {

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = getItem(indexPath: indexPath) else { return }
        diffableDelegate?.diffableTableView?(tableView, didSelectItem: item, indexPath: indexPath)

        if let button = item as? DiffableTableRowButton {
            button.action(indexPath)
        } else if let actionable = item as? DiffableActionableItem {
            actionable.action?(item, indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableTableView?(tableView, leadingSwipeActionsConfigurationForItem: item, at: indexPath)
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableTableView?(tableView, trailingSwipeActionsConfigurationForItem: item, at: indexPath)
    }

    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableTableView?(tableView, contextMenuConfigurationForItem: item, at: indexPath, point: point)
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerItem = getSection(index: section)?.header else { return nil }
        for provider in headerFooterProviders {
            if let view = provider.closure(tableView, section, headerItem) {
                return view
            }
        }
        return nil
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerItem = getSection(index: section)?.footer else { return nil }
        for provider in headerFooterProviders {
            if let view = provider.closure(tableView, section, footerItem) {
                return view
            }
        }
        return nil
    }
}
