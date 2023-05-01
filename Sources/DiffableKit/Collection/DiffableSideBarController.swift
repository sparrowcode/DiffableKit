import UIKit

@available(iOS 14, *)
open class DiffableSideBarController: DiffableCollectionController {
    
    // MARK: - Init
    
    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        collectionView.setCollectionViewLayout(makeLayout(), animated: false)
    }
    
    // MARK: - Layout
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            let header = self?.diffableDataSource?.getSection(index: section)?.header
            configuration.headerMode = (header == nil) ? .none : .firstItemInSection
            let footer = self?.diffableDataSource?.getSection(index: section)?.footer
            configuration.footerMode = (footer == nil) ? .none : .supplementary
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }
    }
}
