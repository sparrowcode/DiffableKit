import UIKit

public protocol DiffableCollectionDelegate: AnyObject {

    func diffableCollectionView(_ collectionView: UICollectionView, didSelectItem item: DiffableItem, indexPath: IndexPath)
    
    func diffableCollectionView(_ collectionView: UICollectionView, didDeselectItem item: DiffableItem, indexPath: IndexPath)
    
    #if canImport(UIKit) && (os(iOS))
    func diffableCollectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    #endif
    
    func diffableCollectionView(_ collectionView: UICollectionView, item: DiffableItem, targetIndexPathForMoveFromItemAt currentIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath
    
    func diffableCollectionView(_ collectionView: UICollectionView, shouldHighlightItem item: DiffableItem, at indexPath: IndexPath) -> Bool
    
    func diffableCollectionView(_ collectionView: UICollectionView, shouldSelectItem item: DiffableItem, at indexPath: IndexPath) -> Bool
    
    // MARK: - Reordering Handlers
    
    // New API of reoder.
    // Can work together with UIDrag & UIDrop Delegates.
    @available(iOS 14.0, *)
    func diffableCollectionViewCanReorderItem(_ item: DiffableItem) -> Bool
    @available(iOS 14.0, *)
    func diffableCollectionViewWillReorder(_ transaction: DiffableCollectionDataSource.Transaction) -> Void
    @available(iOS 14.0, *)
    func diffableCollectionViewDidReorder(_ transaction: DiffableCollectionDataSource.Transaction) -> Void
    
    // MARK: - Layout
    
    func diffableCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    
    func diffableCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
}

public extension DiffableCollectionDelegate {
    
    func diffableCollectionView(_ collectionView: UICollectionView, didSelectItem item: DiffableItem, indexPath: IndexPath) {}
    func diffableCollectionView(_ collectionView: UICollectionView, didDeselectItem item: DiffableItem, indexPath: IndexPath) {}
    
    #if canImport(UIKit) && (os(iOS))
    func diffableCollectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { return nil }
    #endif
    
    func diffableCollectionView(_ collectionView: UICollectionView, item: DiffableItem, targetIndexPathForMoveFromItemAt currentIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath { return proposedIndexPath }
    
    func diffableCollectionView(_ collectionView: UICollectionView, shouldHighlightItem item: DiffableItem, at indexPath: IndexPath) -> Bool { return true }
    
    func diffableCollectionView(_ collectionView: UICollectionView, shouldSelectItem item: DiffableItem, at indexPath: IndexPath) -> Bool { return true }
    
    // MARK: - Reordering Handlers
    
    @available(iOS 14.0, *)
    func diffableCollectionViewCanReorderItem(_ item: DiffableItem) -> Bool { return false }
    @available(iOS 14.0, *)
    func diffableCollectionViewWillReorder(_ transaction: DiffableCollectionDataSource.Transaction) -> Void {}
    @available(iOS 14.0, *)
    func diffableCollectionViewDidReorder(_ transaction: DiffableCollectionDataSource.Transaction) -> Void {}
    
    // MARK: - Layout
    
    func diffableCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { return .zero }
    
    func diffableCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize  { return .zero }
}
