import UIKit

extension DiffableTableDataSource: UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = getItem(indexPath: indexPath) else { return }
        diffableDelegate?.diffableTableView?(tableView, didSelectItem: item, indexPath: indexPath)
        
        switch item {
        case let model as DiffableActionableItem :
            model.action?(item, indexPath)
        default:
            break
        }
    }
    
    #if canImport(UIKit) && (os(iOS))
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableTableView?(tableView, leadingSwipeActionsConfigurationForItem: item, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableTableView?(tableView, trailingSwipeActionsConfigurationForItem: item, at: indexPath)
    }
    #endif
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = self.getSection(index: section)?.header else { return nil }
        for provider in headerFooterProviders {
            if let view = provider.clouser(tableView, section, item) {
                return view
            }
        }
        return nil
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = self.getSection(index: section)?.footer else { return nil }
        for provider in headerFooterProviders {
            if let view = provider.clouser(tableView, section, item) {
                return view
            }
        }
        return nil
    }
    
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        guard let item = getItem(indexPath: indexPath) else { return false }
        return diffableDelegate?.diffableTableView?(tableView, shouldIndentWhileEditingItem: item, indexPath: indexPath) ?? false
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let item = getItem(indexPath: indexPath) else { return .none }
        return diffableDelegate?.diffableTableView?(tableView, editingStyleForItem: item, indexPath: indexPath) ?? .none
    }
}
