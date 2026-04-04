import UIKit

extension DiffableTableDataSource {

    open class HeaderFooterProvider {

        open var closure: Closure

        public init(closure: @escaping Closure) {
            self.closure = closure
        }

        public typealias Closure = (_ tableView: UITableView, _ section: Int, _ item: DiffableItem) -> UIView?
    }
}
