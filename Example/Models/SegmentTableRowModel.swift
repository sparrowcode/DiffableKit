import UIKit

class SwitchTableRowModel: DiffableItem {
    
    var text: String
    var action: (Bool) -> Void
    
    init(text: String, action: @escaping (Bool) -> Void) {
        self.text = text
        self.action = action
        super.init(text)
    }
}
