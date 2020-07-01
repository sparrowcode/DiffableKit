import UIKit

class ActionableSwitch: UISwitch {
    
    var action: (_ state: Bool) -> Void
    
    init(action: @escaping (_ state: Bool) -> Void) {
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
