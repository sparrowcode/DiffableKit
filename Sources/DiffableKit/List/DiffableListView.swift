import UIKit

/* Список-вьюха — замена `DiffableTableView`, когда список не занимает весь контроллер. */
open class DiffableListView: UICollectionView {

    open var diffableDataSource: DiffableListDataSource?

    public var listLayout: DiffableListLayout {
        collectionViewLayout as! DiffableListLayout
    }

    /* Шапка над списком — замена `tableHeaderView`. */
    open var headerView: UIView? {
        get { listLayout.headerView }
        set { listLayout.headerView = newValue }
    }

    // MARK: - Init

    public init(appearance: UICollectionLayoutListConfiguration.Appearance = .insetGrouped) {
        super.init(frame: .zero, collectionViewLayout: DiffableListLayout(appearance: appearance))
        delaysContentTouches = false
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    open func configureDiffable(
        sections: [DiffableSection],
        cellProviders: [DiffableListDataSource.CellProvider],
        headerFooterProviders: [DiffableListDataSource.HeaderFooterProvider] = []
    ) {
        diffableDataSource = DiffableListDataSource(
            collectionView: self,
            cellProviders: cellProviders,
            headerFooterProviders: headerFooterProviders
        )
        diffableDataSource?.set(sections, animated: false)
    }
}
