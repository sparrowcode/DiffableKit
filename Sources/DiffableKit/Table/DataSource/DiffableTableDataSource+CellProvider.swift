import UIKit

extension DiffableTableDataSource {
    
    open class CellProvider {
        
        open var clouser: Clouser
        
        public init(clouser: @escaping Clouser) {
            self.clouser = clouser
        }
        
        public typealias Clouser = (
            _ tableView: UITableView,
            _ indexPath: IndexPath,
            _ item: DiffableItem
        ) -> UITableViewCell?
        
        // MARK: - Ready Use
        
        public static var rowDetail: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                guard let item = item as? DiffableTableRow else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableTableViewCell.reuseIdentifier, for: indexPath) as! DiffableTableViewCell
                cell.textLabel?.text = item.text
                cell.detailTextLabel?.text = item.detail
                cell.imageView?.image = item.icon
                cell.accessoryType = item.accessoryType
                cell.selectionStyle = item.selectionStyle
                return cell
            }
        }
        
        public static var rowSubtitle: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                guard let item = item as? DiffableTableRowSubtitle else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableTableSubtitleViewCell.reuseIdentifier, for: indexPath) as! DiffableTableSubtitleViewCell
                cell.textLabel?.text = item.text
                cell.detailTextLabel?.text = item.subtitle
                cell.imageView?.image = item.icon
                cell.accessoryType = item.accessoryType
                cell.selectionStyle = item.selectionStyle
                return cell
            }
        }
        
        #if os(iOS)
        public static var `switch`: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                guard let item = item as? DiffableTableRowSwitch else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableTableViewCell.reuseIdentifier, for: indexPath) as! DiffableTableViewCell
                
                cell.textLabel?.text = item.text
                cell.imageView?.image = item.icon
                cell.selectionStyle = .none
                
                let configureControl: (_ control: DiffableSwitch) -> Void = { control in
                    control.isOn = item.isOn
                    control.action = { value in
                        item.action(item, indexPath, value)
                    }
                }
                
                if let control = cell.accessoryView as? DiffableSwitch {
                    configureControl(control)
                } else {
                    let control = DiffableSwitch()
                    configureControl(control)
                    cell.accessoryView = control
                }
                
                return cell
            }
        }
        
        public static var stepper: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                guard let item = item as? DiffableTableRowStepper else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableTableViewCell.reuseIdentifier, for: indexPath) as! DiffableTableViewCell
                
                cell.textLabel?.text = item.text
                cell.imageView?.image = item.icon
                cell.selectionStyle = .none
                
                let configureControl: (_ control: DiffableStepper) -> Void = { control in
                    control.stepValue = item.stepValue
                    control.value = item.value
                    control.minimumValue = item.minimumValue
                    control.maximumValue = item.maximumValue
                    control.action = { value in
                        item.action(item, indexPath, value)
                    }
                }
                
                if let control = cell.accessoryView as? DiffableStepper {
                    configureControl(control)
                } else {
                    let control = DiffableStepper()
                    configureControl(control)
                    cell.accessoryView = control
                }
                
                return cell
            }
        }
        #endif
    }
}
