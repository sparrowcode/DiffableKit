import UIKit

/* Список на `UICollectionLayoutListConfiguration`: метрики как у системных Настроек
 (на iOS 27 отступ групп 16 pt, строка 52 pt). Заголовок и футер у секции появляются,
 только если они есть у `DiffableSection`. Свайпы спрашиваются у делегата data source.
 Над списком можно поставить шапку `headerView` — замена `tableHeaderView`.
 https://developer.apple.com/documentation/uikit/uicollectionlayoutlistconfiguration */
@MainActor
open class DiffableListLayout: UICollectionViewCompositionalLayout {

    public static let elementKindListHeader = "DiffableListHeader"

    public let appearance: UICollectionLayoutListConfiguration.Appearance

    /* Шапка над первой секцией. Ширина — во весь список, высоту считает `systemLayoutSizeFitting`
     вьюхи. Горизонтальные отступы шапки совпадают с краями секций: см. `sectionHorizontalInsets`. */
    open var headerView: UIView? {
        didSet {
            guard headerView !== oldValue else { return }
            updateBoundarySupplementaryItems()
        }
    }

    /* Отступы краёв секций от краёв списка из последнего расчёта лейаута. */
    public var sectionHorizontalInsets: NSDirectionalEdgeInsets { context.sectionHorizontalInsets }

    internal let context: DiffableListLayoutContext

    // MARK: - Init

    public init(appearance: UICollectionLayoutListConfiguration.Appearance = .insetGrouped) {
        let context = DiffableListLayoutContext(appearance: appearance)
        self.context = context
        self.appearance = appearance
        super.init(sectionProvider: { sectionIndex, environment in
            MainActor.assumeIsolated {
                context.makeSection(index: sectionIndex, environment: environment)
            }
        })
        context.layout = self
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Header

    /* Пересчитать высоту шапки, если её содержимое поменялось. */
    open func invalidateHeaderView() {
        guard headerView != nil else { return }
        let context = UICollectionViewLayoutInvalidationContext()
        context.invalidateSupplementaryElements(ofKind: Self.elementKindListHeader, at: [IndexPath(item: 0, section: 0)])
        invalidateLayout(with: context)
    }

    private func updateBoundarySupplementaryItems() {
        let configuration = self.configuration
        if headerView == nil {
            configuration.boundarySupplementaryItems = []
        } else {
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)),
                elementKind: Self.elementKindListHeader,
                alignment: .top
            )
            configuration.boundarySupplementaryItems = [header]
        }
        self.configuration = configuration
    }
}

// MARK: - Context

/* Собирает секции лейаута. Отдельный объект, потому что провайдер секций передаётся
 в `super.init` и не может захватить сам лейаут. */
@MainActor
internal final class DiffableListLayoutContext {

    let appearance: UICollectionLayoutListConfiguration.Appearance
    weak var layout: DiffableListLayout?
    weak var dataSource: DiffableListDataSource?
    private(set) var sectionHorizontalInsets: NSDirectionalEdgeInsets = .zero

    init(appearance: UICollectionLayoutListConfiguration.Appearance) {
        self.appearance = appearance
    }

    func makeSection(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
        let section = dataSource?.getSection(index: index)
        configuration.headerMode = section?.header == nil ? .none : .supplementary
        configuration.footerMode = section?.footer == nil ? .none : .supplementary
        configuration.leadingSwipeActionsConfigurationProvider = { [weak dataSource] indexPath in
            dataSource?.leadingSwipeActionsConfiguration(at: indexPath)
        }
        configuration.trailingSwipeActionsConfigurationProvider = { [weak dataSource] indexPath in
            dataSource?.trailingSwipeActionsConfiguration(at: indexPath)
        }

        let layoutSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
        sectionHorizontalInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: layoutSection.contentInsets.leading,
            bottom: 0,
            trailing: layoutSection.contentInsets.trailing
        )
        applyReadableWidth(to: layoutSection)
        return layoutSection
    }

    /* На широком экране (iPad, Mac) секции сужаются до readable width, как ячейки таблицы
     с `cellLayoutMarginsFollowReadableWidth`. На iPhone readable width совпадает с полями
     списка, и `.readableContent` не включаем: иначе на iPhone с полями 20 pt секции встали бы
     на 20 pt вместо системных отступов списка. */
    private func applyReadableWidth(to section: NSCollectionLayoutSection) {
        guard let collectionView = layout?.collectionView else { return }
        let readableFrame = collectionView.readableContentGuide.layoutFrame
        let marginsFrame = collectionView.layoutMarginsGuide.layoutFrame
        guard readableFrame.width < marginsFrame.width else { return }
        section.contentInsetsReference = .readableContent
        section.contentInsets.leading = 0
        section.contentInsets.trailing = 0
        let isRightToLeft = collectionView.effectiveUserInterfaceLayoutDirection == .rightToLeft
        let leftInset = readableFrame.minX - collectionView.bounds.minX
        let rightInset = collectionView.bounds.maxX - readableFrame.maxX
        sectionHorizontalInsets.leading = isRightToLeft ? rightInset : leftInset
        sectionHorizontalInsets.trailing = isRightToLeft ? leftInset : rightInset
    }
}
