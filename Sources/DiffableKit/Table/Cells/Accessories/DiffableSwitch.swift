import UIKit

open class DiffableSwitch: UISwitch {

    var action: (_ state: Bool) -> Void

    #if os(iOS) && !targetEnvironment(macCatalyst)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    #endif

    public init(action: @escaping (_ state: Bool) -> Void) {
        self.action = action
        super.init(frame: .zero)
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func valueChanged() {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        selectionGenerator.selectionChanged()
        #endif
        action(isOn)
    }
}
