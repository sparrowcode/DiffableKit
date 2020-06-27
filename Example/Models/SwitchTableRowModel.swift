import UIKit

class SwitchTableRowModel: DiffableItem {
    
    var text: String
    var isOn: Bool
    var action: Action
    
    init(text: String, isOn: Bool, action: @escaping Action) {
        self.text = text
        self.isOn = isOn
        self.action = action
        super.init(text)
    }
    
    typealias Action = (_ state: Bool) -> Void
}
