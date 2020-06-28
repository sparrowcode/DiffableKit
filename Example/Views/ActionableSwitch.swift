import UIKit

class ActionableSwitch: UISwitch {
    
    var action: SPDiffableTableRowSwitch.Action
    
    init(action: @escaping SPDiffableTableRowSwitch.Action) {
        self.action = action
        super.init(frame: .zero)
        addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func valueChanged() {
        action(isOn)
    }
}
