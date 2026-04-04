import UIKit

open class DiffableCollectionView: UICollectionView {

    open var diffableDataSource: DiffableCollectionDataSource?

    // MARK: - Init

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }

    public convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        delaysContentTouches = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
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
