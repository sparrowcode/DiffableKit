import UIKit

@objc public protocol DiffableListDelegate: AnyObject {

    @objc optional func diffableListView(_ collectionView: UICollectionView, didSelectItem item: DiffableItem, indexPath: IndexPath)

    @objc optional func diffableListView(_ collectionView: UICollectionView, leadingSwipeActionsConfigurationForItem item: DiffableItem, at indexPath: IndexPath) -> UISwipeActionsConfiguration?

    @objc optional func diffableListView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItem item: DiffableItem, at indexPath: IndexPath) -> UISwipeActionsConfiguration?

    @objc optional func diffableListView(_ collectionView: UICollectionView, contextMenuConfigurationForItem item: DiffableItem, at indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
}
