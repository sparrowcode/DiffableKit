import UIKit

open class DiffableCollectionController: UICollectionViewController {
    
    open var diffableDataSource: DiffableCollectionDataSource?
    
    // MARK: - Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delaysContentTouches = false
    }
    
    // MARK: - Configure
    
    open func configureDiffable(
        sections: [DiffableSection],
        cellProviders: [DiffableCollectionDataSource.CellProvider],
        headerFooterProviders: [DiffableCollectionDataSource.HeaderFooterProvider] = []
    ) {
        diffableDataSource = DiffableCollectionDataSource(
            collectionView: collectionView,
            cellProviders: cellProviders,
            headerFooterProviders: headerFooterProviders
        )
        diffableDataSource?.set(sections, animated: false)
    }
}
