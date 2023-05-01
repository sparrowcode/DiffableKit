import UIKit

extension DiffableCollectionDataSource {
    
    open class HeaderFooterProvider {
        
        open var clouser: Clouser
        
        public init(clouser: @escaping Clouser) {
            self.clouser = clouser
        }
        
        public typealias Clouser = (
            _ collectionView: UICollectionView,
            _ section: Int,
            _ item: DiffableItem
        ) -> UICollectionReusableView?
    }
}
