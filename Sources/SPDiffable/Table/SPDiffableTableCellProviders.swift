import UIKit

public enum SPDiffableTableCellProviders {
    
    /**
     Return cell provider, which process for all project models cells.
     No need additional configure.
     
     For change style of cells requerid register new cell provider.
     */
    #warning("Doing split for cell providers")
    public static var `default`: [SPDiffableTableCellProvider] {
        let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, model) -> UITableViewCell? in
            switch model {
            case let model as SPDiffableTableRow:
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
                cell.textLabel?.text = model.text
                cell.detailTextLabel?.text = model.detail
                cell.imageView?.image = model.icon
                cell.accessoryType = model.accessoryType
                cell.selectionStyle = model.selectionStyle
                return cell
            case let model as SPDiffableTableRowSubtitle:
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableSubtitleTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableSubtitleTableViewCell
                cell.textLabel?.text = model.text
                cell.detailTextLabel?.text = model.subtitle
                cell.imageView?.image = model.icon
                cell.accessoryType = model.accessoryType
                cell.selectionStyle = model.selectionStyle
                return cell
            case let item as SPDiffableTableRowSwitch:
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
                cell.textLabel?.text = item.text
                let control = SPDiffableSwitch(action: item.action)
                control.isOn = item.isOn
                cell.accessoryView = control
                cell.selectionStyle = .none
                return cell
            case let item as SPDiffableTableRowStepper:
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
                cell.textLabel?.text = item.text
                let control = SPDiffableStepper(action: item.action)
                control.stepValue = item.stepValue
                control.value = item.value
                control.minimumValue = item.minimumValue
                control.maximumValue = item.maximumValue
                cell.accessoryView = control
                cell.selectionStyle = .none
                return cell
            default:
                return nil
            }
        }
        return [cellProvider]
    }
}
