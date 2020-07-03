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
            let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, model) -> UITableViewCell? in
                switch model {
                case let model as SPDiffableTableRow:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
                    cell.textLabel?.text = model.text
                    cell.detailTextLabel?.text = model.detail
                    cell.accessoryType = model.accessoryType
                    cell.selectionStyle = model.selectionStyle
                    return cell
                case let model as SPDiffableTableRowSwitch:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
                    cell.textLabel?.text = model.text
                    let control = ActionableSwitch(action: model.action)
                    control.isOn = model.isOn
                    cell.accessoryView = control
                    cell.selectionStyle = .none
                    return cell
                case let model as SPDiffableTableRowStepper:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
                    cell.textLabel?.text = model.text
                    let control = ActionableStepper(action: model.action)
                    control.value = Double(model.value)
                    control.minimumValue = Double(model.minimumValue)
                    control.maximumValue = Double(model.maximumValue)
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
