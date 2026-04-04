import UIKit

open class DiffableStepper: UIStepper {

    var action: (_ value: Double) -> Void

    public init(action: @escaping (_ value: Double) -> Void) {
        self.action = action
        super.init(frame: .zero)
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func valueChanged() {
        action(value)
    }
}
