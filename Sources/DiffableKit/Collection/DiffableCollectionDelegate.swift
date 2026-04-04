import UIKit

@objc public protocol DiffableCollectionDelegate: AnyObject {

    @objc optional func diffableCollectionView(_ collectionView: UICollectionView, didSelectItem item: DiffableItem, indexPath: IndexPath)
}
