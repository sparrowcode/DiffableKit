import UIKit

@available(iOS 14, *)
open class DiffableSideBarButtonItem: DiffableActionableItem {
    
    open var title: String
    open var image: UIImage?
    open var isEnabled: Bool
    open var accessories: [UICellAccessory]
    
    public init(id: String? = nil, title: String, image: UIImage?, isEnabled: Bool = true, accessories: [UICellAccessory] = [], action: @escaping Action) {
        self.title = title
        self.image = image
        self.isEnabled = isEnabled
        self.accessories = accessories
        super.init(id: id ?? title, action: action)
    }
}
