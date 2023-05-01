import UIKit

class AppleCollectionDiffableDataSource: UICollectionViewDiffableDataSource<DiffableSection, DiffableItem> {
    
    // MARK: - Init
    
    init(
        collectionView: UICollectionView,
        cellProvider: @escaping CellProvider,
        headerFooterProvider: SupplementaryViewProvider?
    ) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        self.supplementaryViewProvider = headerFooterProvider
    }
    
    // MARK: - Wrappers
    
    @available(tvOS 13.0, *)
    typealias Snapshot = NSDiffableDataSourceSnapshot<DiffableSection, DiffableItem>
    
    @available(iOS 14.0, tvOS 14, *)
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<DiffableItem>
}
