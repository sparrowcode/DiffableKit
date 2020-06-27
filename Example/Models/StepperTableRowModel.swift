import UIKit

class StepperTableRowModel: DiffableItem {
    
    var text: String
    var value: Int
    var minimumValue: Int
    var maximumValue: Int
    var action: Action
    
    init(text: String, value: Int, minimumValue: Int, maximumValue: Int, action: @escaping Action) {
        self.text = text
        self.value = value
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.action = action
        super.init(text)
    }
    
    typealias Action = (_ value: Int) -> Void
}
