import UIKit

extension DiffableCollectionDataSource {

    open class CellProvider {

        open var closure: Closure

        public init(closure: @escaping Closure) {
            self.closure = closure
        }

        public typealias Closure = @MainActor (_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: DiffableItem) -> UICollectionViewCell?
    }
}
