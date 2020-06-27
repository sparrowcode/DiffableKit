import UIKit

class RootController: DiffableTableController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SPDiffable Examples"
    }
    
    enum Section: String {
        
        case basic = "basic"
        case accessory = "accessory"
        case checkmark = "checkmark"
        case customCellProvider = "customCellProvider"
        
        var identifier: String {
            return rawValue
        }
    }
    
    override var content: [SPDiffableSection] {
        
        let accessorySection = SPDiffableSection(
            identifier: Section.accessory.identifier, header: SPDiffableTextHeader(text: "Accessory"), footer: SPDiffableTextFooter(text: "Getting default value before show. After changes in elements you can check prints in console."),
            items: [
                SwitchTableRowModel(text: "Switch", isOn: switchOn, action: { [weak self] (isOn) in
                    guard let self = self else { return }
                    self.switchOn = isOn
                    
                }),
                StepperTableRowModel(text: "Stepper", value: stepperValue, minimumValue: -5, maximumValue: 5, action: { [weak self] (value) in
                    guard let self = self else { return }
                    self.stepperValue = value
                })
            ]
        )
        
        let basicSection = SPDiffableSection(
            identifier: Section.basic.identifier, header: SPDiffableTextHeader(text: "Presenter"), footer: SPDiffableTextFooter(text: "Push in navigation processing by table controller. Sometimes you need manually deselect cell."),
            items: [
                NativeTableRowModel(text: "Basic Deselect", detail: nil, accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }),
                NativeTableRowModel(text: "Basic Push", detail: nil, accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            ]
        )
        
        if switchOn {
            accessorySection.items.insert(NativeTableRowModel(text: "Switch Worked", detail: nil, accessoryType: .checkmark, selectionStyle: .none, action: nil), at: 1)
        }
        
        if stepperValue != 0 {
            accessorySection.items.append(stepperDiffableRowModel)
        }
        
        let checkmarkSections = SPDiffableSection(
            identifier: Section.checkmark.identifier, header: nil, footer: SPDiffableTextFooter(text: "Example how usage search by models and change checkmark without reload table."),
            items: [
                NativeTableRowModel(text: "Chekmarks", detail: nil, accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            ]
        )
        
        let cellProviderSection = SPDiffableSection(
            identifier: Section.customCellProvider.identifier, header: nil, footer: SPDiffableTextFooter(text: "Also you can add more providers for specific controller, and use default and custom specially for some contorllers."),
            items: [
                NativeTableRowModel(text: "Custom Cell Provider", detail: nil, accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            ]
        )
        
        return [accessorySection, basicSection, checkmarkSections, cellProviderSection]
    }
    
    private var switchOn: Bool = false {
        didSet {
            print("Switch is on: \(switchOn)")
            updateContent()
        }
    }
    
    private var stepperValue: Int = 0 {
        didSet {
            print("Stepper value is: \(stepperValue)")
            updateContent()
            guard let indexPath = diffableDataSource?.indexPath(for: stepperDiffableRowModel), let cell = tableView.cellForRow(at: indexPath) else { return }
            cell.detailTextLabel?.text = stepperDiffableRowModel.detail
        }
    }
    
    private var stepperDiffableRowModel: NativeTableRowModel {
        return NativeTableRowModel(text: "Stepper Value", detail: "\(stepperValue)", accessoryType: .none, selectionStyle: .none, action: nil)
    }
}

