import UIKit

extension DiffableCollectionDataSource: UICollectionViewDelegate {

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = getItem(indexPath: indexPath) else { return }
        diffableDelegate?.diffableCollectionView?(collectionView, didSelectItem: item, indexPath: indexPath)

        if let actionable = item as? DiffableActionableItem {
            actionable.action?(item, indexPath)
        }
    }
}
