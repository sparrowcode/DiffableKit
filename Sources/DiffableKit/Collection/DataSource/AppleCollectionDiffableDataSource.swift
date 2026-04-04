import UIKit

class AppleCollectionDiffableDataSource: UICollectionViewDiffableDataSource<String, String> {

    init(
        collectionView: UICollectionView,
        cellProvider: @escaping CellProvider,
        headerFooterProvider: SupplementaryViewProvider?
    ) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        self.supplementaryViewProvider = headerFooterProvider
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>
}
