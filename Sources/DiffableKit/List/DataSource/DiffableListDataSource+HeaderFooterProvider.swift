import UIKit

extension DiffableListDataSource {

    /* Свой заголовок или футер секции. Текстовые (`DiffableTextHeaderFooter`) список рисует сам. */
    open class HeaderFooterProvider {

        open var closure: Closure

        public init(closure: @escaping Closure) {
            self.closure = closure
        }

        public typealias Closure = @MainActor (_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath, _ item: DiffableItem) -> UICollectionReusableView?
    }
}
