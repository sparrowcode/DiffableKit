import UIKit

open class DiffableTableRowStepper: DiffableItem {

    open var text: String
    open var icon: UIImage?
    open var stepValue: Double
    open var value: Double
    open var minimumValue: Double
    open var maximumValue: Double
    open var action: Action

    public init(
        id: String? = nil,
        text: String,
        icon: UIImage? = nil,
        stepValue: Double,
        value: Double,
        minimumValue: Double,
        maximumValue: Double,
        action: @escaping Action
    ) {
        self.text = text
        self.icon = icon
        self.stepValue = stepValue
        self.value = value
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.action = action
        super.init(id: id ?? text)
    }

    public typealias Action = (_ value: Double) -> Void
}
