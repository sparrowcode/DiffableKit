import UIKit

/**
 Default controller, which allow using one cell and models many times.
 If need custom cell provider, need call method `setCellProviders`.
 */
class DiffableTableController: SPDiffableTableController, SPTableDiffableMediator {
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NativeTableViewCell.self, forCellReuseIdentifier: NativeTableViewCell.identifier)
        setCellProviders([CellProvider.default], sections: content)
        diffableDataSource?.mediator = self
    }
    
    /**
     Universal property for content. Ovveride it in next controllers.
     You can not use it.
     */
    var content: [SPDiffableSection] {
        return []
    }
    
    /**
     Wrapper func for update content from `content` property.
     */
    internal func updateContent(animating: Bool) {
        diffableDataSource?.apply(sections: content, animating: animating)
    }
    
    /**
     Process action from models.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch diffableDataSource?.itemIdentifier(for: indexPath) {
        case let model as SPDiffableTableRow:
            model.action?(indexPath)
        default:
            break
        }
    }
    
    /**
     Defaul cell provider.
     Here shoud process all cells which using many times in projects.
     */
    enum CellProvider {
        
        static var `default`: SPDiffableTableCellProvider {
            let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, item) -> UITableViewCell? in
                switch item {
                case let item as SPDiffableTableRow:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
                    cell.textLabel?.text = item.text
                    cell.detailTextLabel?.text = item.detail
                    cell.accessoryType = item.accessoryType
                    cell.selectionStyle = item.selectionStyle
                    return cell
                case let item as SPDiffableTableRowSwitch:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
                    cell.textLabel?.text = item.text
                    let control = ActionableSwitch(action: item.action)
                    control.isOn = item.isOn
                    cell.accessoryView = control
                    cell.selectionStyle = .none
                    return cell
                case let item as SPDiffableTableRowStepper:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
                    cell.textLabel?.text = item.text
                    let control = ActionableStepper(action: item.action)
                    control.value = Double(item.value)
                    control.minimumValue = Double(item.minimumValue)
                    control.maximumValue = Double(item.maximumValue)
                    cell.accessoryView = control
                    cell.selectionStyle = .none
                    return cell
                default:
                    return nil
                }
            }
            return cellProvider
        }
    }
}
