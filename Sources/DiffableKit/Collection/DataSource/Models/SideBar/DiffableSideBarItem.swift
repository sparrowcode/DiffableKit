import UIKit

@available(iOS 14, *)
open class DiffableSideBarItem: DiffableActionableItem {
    
    open var title: String
    open var image: UIImage?
    open var isEnabled: Bool
    open var higlight: Higlight
    open var accessories: [UICellAccessory]
    
    public init(id: String? = nil, title: String, image: UIImage?, isEnabled: Bool = true, higlight: Higlight = .bg, accessories: [UICellAccessory] = [], action: @escaping Action) {
        self.title = title
        self.image = image
        self.isEnabled = isEnabled
        self.higlight = higlight
        self.accessories = accessories
        super.init(id: id ?? title, action: action)
    }
    
    public enum Higlight {
        
        case bg
        case content
    }
}
