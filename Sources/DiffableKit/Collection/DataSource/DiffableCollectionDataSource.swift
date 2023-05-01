import UIKit

@available(iOS 13.0, tvOS 13, *)
open class DiffableCollectionDataSource: NSObject, DiffableDataSourceInterface {
    
    open weak var diffableDelegate: DiffableCollectionDelegate? {
        didSet {
            if #available(iOS 14.0, *) {
                if let delegate = self.diffableDelegate {
                    self.appleDiffableDataSource?.reorderingHandlers.canReorderItem = { item in
                        return self.diffableDelegate?.diffableCollectionViewCanReorderItem(item) ?? false
                    }
                    self.appleDiffableDataSource?.reorderingHandlers.willReorder = { transaction in
                        delegate.diffableCollectionViewWillReorder(transaction)
                    }
                    self.appleDiffableDataSource?.reorderingHandlers.didReorder = { transaction in
                        delegate.diffableCollectionViewDidReorder(transaction)
                    }
                } else {
                    self.appleDiffableDataSource?.reorderingHandlers.canReorderItem = nil
                    self.appleDiffableDataSource?.reorderingHandlers.willReorder = nil
                    self.appleDiffableDataSource?.reorderingHandlers.didReorder = nil
                }
            }
        }
    }
    
    private var appleDiffableDataSource: AppleCollectionDiffableDataSource?
    private weak var collectionView: UICollectionView?
    
    // MARK: - Init
    
    public init(
        collectionView: UICollectionView,
        cellProviders: [CellProvider],
        headerFooterProviders: [HeaderFooterProvider]
    ) {
        self.collectionView = collectionView
        
        super.init()
        self.appleDiffableDataSource = .init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                for provider in cellProviders {
                    if let cell = provider.clouser(collectionView, indexPath, item) {
                        return cell
                    }
                }
                return nil
            },
            headerFooterProvider: { collectionView, elementKind, indexPath in
                for provider in headerFooterProviders {
                    let sectionIndex = indexPath.section
                    guard let section = self.getSection(index: sectionIndex) else { break }
                    switch elementKind {
                    case UICollectionView.elementKindSectionHeader:
                        guard let headerItem = section.header else { continue }
                        if let view = provider.clouser(collectionView, sectionIndex, headerItem) {
                            return view
                        }
                    case UICollectionView.elementKindSectionFooter:
                        guard let footerItem = section.footer else { continue }
                        if let view = provider.clouser(collectionView, sectionIndex, footerItem) {
                            return view
                        }
                    default:
                        return nil
                    }
                }
                return nil
            }
        )
        
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dragInteractionEnabled = true
    }
    
    // MARK: - DiffableDataSourceInterface
    
    // MARK: Set
    
    public func set(_ sections: [DiffableSection], animated: Bool, completion: (() -> Void)? = nil) {
        
        let convertToSnapshot: ((_ sections: [DiffableSection]) -> AppleTableDiffableDataSource.Snapshot) = { sections in
            var snapshot = AppleCollectionDiffableDataSource.Snapshot()
            snapshot.appendSections(sections)
            for section in sections {
                snapshot.appendItems(section.items, toSection: section)
            }
            return snapshot
        }
        
        // 1. Add, remove & reoder
        
        let newSnaphsot = convertToSnapshot(sections)
        appleDiffableDataSource?.apply(newSnaphsot, animatingDifferences: animated, completion: completion)
        
        // 2. Update visible cells
        
        var items: [DiffableItem] = []
        for indexPath in self.collectionView?.indexPathsForVisibleItems ?? [] {
            if let item = getItem(indexPath: indexPath) {
                items.append(item)
            }
        }
        
        if !items.isEmpty {
            reconfigure(items)
        }
        
        #warning("maybe it may crash side bar. for now collection work well without it.")
        #warning("complex logic was dropped")
        #warning("decide to later")
        if #available(iOS 14.0, tvOS 14, *) {
            for section in sections {
                var sectionSnapshot = AppleCollectionDiffableDataSource.SectionSnapshot()
                if let collectionSection = section as? DiffableCollectionSection, collectionSection.headerProcess == .headerIsFirstCell {
                    if let header = section.header {
                        sectionSnapshot.append([header])
                        sectionSnapshot.append(section.items, to: header)
                    } else {
                        sectionSnapshot.append(section.items, to: nil)
                    }
                } else {
                    sectionSnapshot.append(section.items)
                }
                
                if let section = section as? DiffableCollectionSection {
                    if section.expanded {
                        sectionSnapshot.expand(sectionSnapshot.items)
                    } else {
                        sectionSnapshot.collapse(sectionSnapshot.items)
                    }
                } else {
                    sectionSnapshot.expand(sectionSnapshot.items)
                }
                
                appleDiffableDataSource?.apply(sectionSnapshot, to: section, animatingDifferences: animated)
            }
        }
    }
    
    public func reconfigure(_ items: [DiffableItem]) {
        guard var snapshot = appleDiffableDataSource?.snapshot() else { return }
        if #available(iOS 15.0, tvOS 15, *) {
            snapshot.reconfigureItems(items)
        } else {
            snapshot.reloadItems(items)
        }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: Get
    
    public func getItem(id: String) -> DiffableItem? {
        let snapshot = appleDiffableDataSource?.snapshot()
        return snapshot?.itemIdentifiers.first(where: { $0.id == id })
    }
    
    public func getItem(indexPath: IndexPath) -> DiffableItem? {
        return appleDiffableDataSource?.itemIdentifier(for: indexPath)
    }
    
    public func getSection(id: String) -> DiffableSection? {
        return appleDiffableDataSource?.snapshot().sectionIdentifiers.first(where: { $0.id == id })
    }
    
    public func getSection(index: Int) -> DiffableSection? {
        if #available(iOS 15.0, *) {
            return appleDiffableDataSource?.sectionIdentifier(for: index)
        } else {
            guard let snapshot = appleDiffableDataSource?.snapshot() else { return nil }
            guard index < snapshot.sectionIdentifiers.count else { return nil }
            return snapshot.sectionIdentifiers[index]
        }
    }
    
    public func getIndexPath(id: String) -> IndexPath? {
        guard let item = getItem(id: id) else { return nil }
        return appleDiffableDataSource?.indexPath(for: item)
    }
    
    public func getIndexPath(item: DiffableItem) -> IndexPath? {
        return appleDiffableDataSource?.indexPath(for: item)
    }
    
    @available(iOS 14.0, *)
    public typealias Transaction = (NSDiffableDataSourceTransaction<DiffableSection, DiffableItem>)
}
