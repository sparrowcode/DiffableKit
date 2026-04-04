import UIKit

extension DiffableCollectionDataSource {

    open class HeaderFooterProvider {

        open var closure: Closure

        public init(closure: @escaping Closure) {
            self.closure = closure
        }

        public typealias Closure = (_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath, _ item: DiffableItem) -> UICollectionReusableView?
    }
}
