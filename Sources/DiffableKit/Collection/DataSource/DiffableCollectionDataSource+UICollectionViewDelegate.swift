import UIKit

extension DiffableCollectionDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    #if os(iOS)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return self.diffableDelegate?.diffableCollectionView(collectionView, contextMenuConfigurationForItemAt: indexPath, point: point)
    }
    #endif
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = getItem(indexPath: indexPath) else { return }
        diffableDelegate?.diffableCollectionView(collectionView, didSelectItem: item, indexPath: indexPath)
        switch item {
        case let item as DiffableActionableItem:
            item.action?(item, indexPath)
        default:
            break
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let item = getItem(indexPath: indexPath) else { return }
        diffableDelegate?.diffableCollectionView(collectionView, didDeselectItem: item, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let item = getItem(indexPath: indexPath) else { fatalError() }
        return diffableDelegate?.diffableCollectionView(collectionView, shouldHighlightItem: item, at: indexPath) ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let item = getItem(indexPath: indexPath) else { fatalError() }
        return diffableDelegate?.diffableCollectionView(collectionView, shouldSelectItem: item, at: indexPath) ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt currentIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        guard let item = getItem(indexPath: currentIndexPath) else { fatalError() }
        return diffableDelegate?.diffableCollectionView(collectionView, item: item, targetIndexPathForMoveFromItemAt: currentIndexPath, toProposedIndexPath: proposedIndexPath) ?? proposedIndexPath
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return diffableDelegate?.diffableCollectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return diffableDelegate?.diffableCollectionView(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section) ?? .zero
    }
}
