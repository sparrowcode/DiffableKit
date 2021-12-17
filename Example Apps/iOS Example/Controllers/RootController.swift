// The MIT License (MIT)
// Copyright © 2020 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import SPDiffable

@available(iOS 13.0, *)
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
        
        var id: String {
            return rawValue
        }
    }
    
    override var content: [SPDiffableSection] {
        
        var content: [SPDiffableSection] = []
        
        let accessorySection = SPDiffableSection(
            id: Section.accessory.id,
            header: SPDiffableTextHeaderFooter(text: "Accessory"),
            footer: SPDiffableTextHeaderFooter(text: "Getting default value before show. After changes in elements you can check prints in console."),
            items: [
                SPDiffableTableRowSwitch(text: "Switch", isOn: switchOn, action: { [weak self] (isOn) in
                    guard let self = self else { return }
                    self.switchOn = isOn
                    
                }),
                SPDiffableTableRowStepper(text: "Stepper", stepValue: 1, value: stepperValue, minimumValue: -5, maximumValue: 5, action: { [weak self] (value) in
                    guard let self = self else { return }
                    self.stepperValue = value
                })
            ]
        )
        content.append(accessorySection)
        
        let basicSection = SPDiffableSection(
            id: Section.basic.id,
            header: SPDiffableTextHeaderFooter(text: "Presenter"),
            footer: SPDiffableTextHeaderFooter(text: "Push in navigation processing by table controller. Sometimes you need manually deselect cell."),
            items: [
                SPDiffableTableRow(text: "Deselect", accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] model, indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }),
                SPDiffableTableRow(text: "Push", accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] model, indexPath in
                    guard let self = self else { return }
                    let controller = UIViewController()
                    controller.view.backgroundColor = .secondarySystemGroupedBackground
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            ]
        )
        content.append(basicSection)
        
        if switchOn {
            accessorySection.items.insert(SPDiffableTableRow(text: "Switch Worked", accessoryType: .checkmark), at: 1)
        }
        
        if stepperValue != 0 {
            accessorySection.items.append(
                SPDiffableTableRow(id: stepperValueIdentifier, text: "Stepper Value", detail: "\(Int(stepperValue))")
            )
        }
        
        if #available(iOS 14, *) {
            let sideBarSections = SPDiffableSection(
                id: Section.sidebar.id,
                footer: SPDiffableTextHeaderFooter(text: "Example of new Side Bar."),
                items: [
                    SPDiffableTableRow(text: "Present Side Bar", accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] model, indexPath in
                        guard let self = self else { return }
                        self.tableView.deselectRow(at: indexPath, animated: true)
                        let sideBarController = SideBarSplitController()
                        sideBarController.modalPresentationStyle = .fullScreen
                        self.present(sideBarController, animated: true)
                    })
                ]
            )
            content.append(sideBarSections)
        }
        
        let checkmarkSections = SPDiffableSection(
            id: Section.checkmark.id,
            footer: SPDiffableTextHeaderFooter(text: "Example how usage search by models and change checkmark without reload table."),
            items: [
                SPDiffableTableRow(text: "Chekmarks", accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] model, indexPath in
                    guard let self = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            ]
        )
        content.append(checkmarkSections)
        
        let cellProviderSection = SPDiffableSection(
            id: Section.customCellProvider.id,
            footer: SPDiffableTextHeaderFooter(text: "Also you can add more providers for specific controller, and use default and custom specially for some contorllers."),
            items: [
                SPDiffableTableRow(text: "Custom Cell Provider", accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] model, indexPath in
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
            updateContent(animated: true)
        }
    }
    
    private var stepperValue: Double = 0 {
        didSet {
            print("Stepper value is: \(stepperValue)")
            updateContent(animated: true)
            guard let indexPath = diffableDataSource?.indexPath(for: stepperValueIdentifier), let cell = tableView.cellForRow(at: indexPath) else { return }
            cell.detailTextLabel?.text = "\(Int(stepperValue))"
        }
    }
    
    private var stepperValueIdentifier: String { return "Stepper Value Identifier" }
}

