import UIKit

extension DiffableTableDataSource {
    
    open class HeaderFooterProvider {
        
        open var clouser: Clouser
        
        public init(clouser: @escaping Clouser) {
            self.clouser = clouser
        }
        
        public typealias Clouser = (
            _ tableView: UITableView,
            _ section: Int,
            _ item: DiffableItem
        ) -> UIView?
    }
}
