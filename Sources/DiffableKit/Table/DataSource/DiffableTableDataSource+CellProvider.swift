import UIKit

extension DiffableTableDataSource {
    
    open class CellProvider {
        
        open var clouser: Clouser
        
        public init(clouser: @escaping Clouser) {
            self.clouser = clouser
        }
        
        public typealias Clouser = (
            _ tableView: UITableView,
            _ indexPath: IndexPath,
            _ item: DiffableItem
        ) -> UITableViewCell?
    }
}
