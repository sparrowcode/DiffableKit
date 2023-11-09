#if canImport(UIKit) && os(iOS)
import UIKit

open class DiffableSwitch: UISwitch {
    
    public var action: (_ state: Bool) -> Void = { _ in }
    
    public init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
    }
    
    required public init?(coder: NSCoder) {
        self.action = { _ in }
        super.init(coder: coder)
    }
    
    @objc func valueChanged() {
        action(isOn)
    }
}
#endif
