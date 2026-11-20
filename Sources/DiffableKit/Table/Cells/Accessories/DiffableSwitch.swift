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

    /* Value from the row. A switch already on screen moves with the system animation, as when the
       app changes it in response to another control; a new or reused one jumps into place. */
    func update(isOn: Bool) {
        guard isOn != self.isOn else { return }
        setOn(isOn, animated: window != nil)
    }

    @objc private func valueChanged() {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        selectionGenerator.selectionChanged()
        #endif
        action(isOn)
    }
}
