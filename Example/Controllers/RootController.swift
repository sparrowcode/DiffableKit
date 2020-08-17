import UIKit

class RootController: DiffableTableController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SPDiffable Examples"
    }
    
    enum Section: String {
        
        case basic = "basic"
        case sidebar = "sidebar"
        case accessory = "accessory"
        case checkmark = "checkmark"
        case customCellProvider = "customCellProvider"
        
        var identifier: String {
            return rawValue
        }
    }
    
    override var content: [SPDiffableSection] {
        
        var content: [SPDiffableSection] = []
        
        let accessorySection = SPDiffableSection(
            identifier: Section.accessory.identifier,
            header: SPDiffableTextHeaderFooter(text: "Accessory"),
            footer: SPDiffableTextHeaderFooter(text: "Getting default value before show. After changes in elements you can check prints in console."),
            items: [
                SPDiffableTableRowSwitch(text: "Switch", isOn: switchOn, action: { [weak self] (isOn) in
                    guard let self = self else { return }
                    self.switchOn = isOn
                    
                }),
                SPDiffableTableRowStepper(text: "Stepper", value: stepperValue, minimumValue: -5, maximumValue: 5, action: { [weak self] (value) in
                    guard let self = self else { return }
                    self.stepperValue = value
                })
            ]
        )
        content.append(accessorySection)
        
        let basicSection = SPDiffableSection(
            identifier: Section.basic.identifier,
            header: SPDiffableTextHeaderFooter(text: "Presenter"),
            footer: SPDiffableTextHeaderFooter(text: "Push in navigation processing by table controller. Sometimes you need manually deselect cell."),
            items: [
                SPDiffableTableDefaultRow(text: "Basic Deselect", accessoryType: .disclosureIndicator, action: { [weak self] indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }),
                SPDiffableTableDefaultRow(text: "Basic Push", accessoryType: .disclosureIndicator, action: { [weak self] indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            ]
        )
        content.append(basicSection)
        
        if switchOn {
            accessorySection.items.insert(SPDiffableTableDefaultRow(text: "Switch Worked", accessoryType: .checkmark), at: 1)
        }
        
        if stepperValue != 0 {
            accessorySection.items.append(stepperValueDiffableRow)
        }
        
        let checkmarkSections = SPDiffableSection(
            identifier: Section.checkmark.identifier,
            footer: SPDiffableTextHeaderFooter(text: "Example how usage search by models and change checkmark without reload table."),
            items: [
                SPDiffableTableDefaultRow(text: "Chekmarks", accessoryType: .disclosureIndicator, action: { [weak self] indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            ]
        )
        content.append(checkmarkSections)
        
        let cellProviderSection = SPDiffableSection(
            identifier: Section.customCellProvider.identifier,
            footer: SPDiffableTextHeaderFooter(text: "Also you can add more providers for specific controller, and use default and custom specially for some contorllers."),
            items: [
                SPDiffableTableDefaultRow(text: "Custom Cell Provider", accessoryType: .disclosureIndicator, action: { [weak self] indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            ]
        )
        content.append(cellProviderSection)
        
        return content
    }
    
    private var switchOn: Bool = false {
        didSet {
            print("Switch is on: \(switchOn)")
            updateContent(animating: true)
        }
    }
    
    private var stepperValue: Int = 0 {
        didSet {
            print("Stepper value is: \(stepperValue)")
            updateContent(animating: true)
            guard let indexPath = diffableDataSource?.indexPath(for: stepperValueDiffableRow), let cell = tableView.cellForRow(at: indexPath) else { return }
            cell.detailTextLabel?.text = stepperValueDiffableRow.detail
        }
    }
    
    private var stepperValueDiffableRow: SPDiffableTableDefaultRow {
        return SPDiffableTableDefaultRow(text: "Stepper Value", detail: "\(stepperValue)", accessoryType: .none)
    }
}

