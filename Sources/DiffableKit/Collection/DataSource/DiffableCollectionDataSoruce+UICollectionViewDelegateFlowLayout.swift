import UIKit

extension DiffableCollectionDataSource: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return diffableLayoutDelegate?.diffableCollectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return diffableLayoutDelegate?.diffableCollectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? .zero
    }
}
