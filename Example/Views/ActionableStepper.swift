import UIKit

class ActionableStepper: UIStepper {
    
    var action: (_ value: Int) -> Void
    
    init(action: @escaping (Int) -> Void) {
        self.action = action
        super.init(frame: .zero)
        addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func valueChanged() {
        action(Int(value))
    }
}
