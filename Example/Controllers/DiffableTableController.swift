import UIKit

class DiffableTableController: SPDiffableTableController {
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(NativeTableViewCell.self, forCellReuseIdentifier: NativeTableViewCell.identifier)
        setCellProviders([CellProvider.default], sections: content)
    }
    
    internal func updateContent() {
        diffableDataSource?.apply(sections: content, animating: true)
    }
    
    var content: [DiffableSection] {
        return []
    }  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch diffableDataSource?.itemIdentifier(for: indexPath) {
        case let model as NativeTableRowModel:
            model.action?(indexPath)
        default:
            break
        }
    }
    
    enum CellProvider {
        
        static var `default`: SPTableDiffableDataSource.CellProvider {
            let cellProvider: SPTableDiffableDataSource.CellProvider = { (tableView, indexPath, model) -> UITableViewCell? in
                switch model {
                case let model as NativeTableRowModel:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
                    cell.textLabel?.text = model.text
                    cell.detailTextLabel?.text = model.detail
                    cell.accessoryType = model.accessoryType
                    cell.selectionStyle = model.selectionStyle
                    return cell
                case let model as SwitchTableRowModel:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
                    cell.textLabel?.text = model.text
                    let control = ActionableSwitch(action: model.action)
                    control.isOn = model.isOn
                    cell.accessoryView = control
                    cell.selectionStyle = .none
                    return cell
                case let model as StepperTableRowModel:
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
