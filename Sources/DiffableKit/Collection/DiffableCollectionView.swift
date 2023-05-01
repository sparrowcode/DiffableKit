import UIKit

@available(iOS 13.0, tvOS 13, *)
open class DiffableCollectionView: UICollectionView {
    
    open var diffableDataSource: DiffableCollectionDataSource?
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delaysContentTouches = false
    }
    
    // MARK: - Configure
    
    open func configureDiffable(
        sections: [DiffableSection],
        cellProviders: [DiffableCollectionDataSource.CellProvider],
        headerFooterProviders: [DiffableCollectionDataSource.HeaderFooterProvider] = []
    ) {
        diffableDataSource = DiffableCollectionDataSource(
            collectionView: self,
            cellProviders: cellProviders,
            headerFooterProviders: headerFooterProviders
        )
        diffableDataSource?.set(sections, animated: false)
    }
}
