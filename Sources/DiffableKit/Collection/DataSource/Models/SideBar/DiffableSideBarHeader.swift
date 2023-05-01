import UIKit

@available(iOS 14, *)
open class DiffableSideBarHeader: DiffableItem {
    
    open var text: String
    open var accessories: [UICellAccessory]
    
    public init(id: String? = nil, text: String, accessories: [UICellAccessory] = []) {
        self.text = text
        self.accessories = accessories
        super.init(id: id ?? text)
    }
}
