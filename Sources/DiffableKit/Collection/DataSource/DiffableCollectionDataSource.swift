import UIKit

@available(iOS 13.0, tvOS 13, *)
open class DiffableCollectionDataSource: NSObject, DiffableDataSourceInterface {
    
    public func set(_ sections: [DiffableSection], animated: Bool, completion: (() -> Void)?) {
        
    }
    
    public func getItem(id: String) -> DiffableItem? {
        return nil
    }
    
    public func getItem(indexPath: IndexPath) -> DiffableItem? {
        return nil
    }
    
    public func getSection(id: String) -> DiffableSection? {
        return nil
    }
    
    public func getSection(index: Int) -> DiffableSection? {
        return nil
    }
    
    public func getIndexPath(id: String) -> IndexPath? {
        return nil
    }
    
    public func getIndexPath(item: DiffableItem) -> IndexPath? {
        return nil
    }
    
    
}
