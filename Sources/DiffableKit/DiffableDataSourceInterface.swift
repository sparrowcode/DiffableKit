import UIKit

@available(iOS 13.0, *)
public protocol DiffableDataSourceInterface: AnyObject {
    
    // MARK: - Set
    
    func set(_ sections: [DiffableSection], animated: Bool, completion: (() -> Void)?)
    
    // MARK: - Get
    
    func getItem(id: String) -> DiffableItem?
    func getItem(indexPath: IndexPath) -> DiffableItem?
    func getSection(id: String) -> DiffableSection?
    func getSection(index: Int) -> DiffableSection?
    func getIndexPath(id: String) -> IndexPath?
    func getIndexPath(item: DiffableItem) -> IndexPath?
}
