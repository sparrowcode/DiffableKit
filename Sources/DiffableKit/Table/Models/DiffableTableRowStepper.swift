import UIKit

open class DiffableTableRowStepper: DiffableItem {
    
    open var stepValue: Double
    open var value: Double
    open var minimumValue: Double
    open var maximumValue: Double
    open var text: String
    open var icon: UIImage? = nil
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
    
    open override var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? DiffableItem else { return false }
        return id == object.id
    }
    
    public typealias Action = (_ item: DiffableItem, _ indexPath: IndexPath, _ value: Double) -> Void
}
