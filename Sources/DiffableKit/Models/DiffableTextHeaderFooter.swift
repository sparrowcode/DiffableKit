import UIKit

open class DiffableTextHeaderFooter: DiffableItem {
    
    open var text: String
    
    public init(id: String? = nil, text: String) {
        self.text = text
        super.init(id: id ?? text)
    }
}
