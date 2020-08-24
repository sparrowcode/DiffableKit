import UIKit

public enum SPDiffableCollectionCellProviders {
    
    /**
     Defaults cell provider, which can help you doing side bar faster.
     You can do your providers and ise its with more flexible.
     */
    #warning("Doing split for cell providers")
    @available(iOS 14, *)
    public static var sideBar: [SPDiffableCollectionCellProvider] {
        let cellProvider: SPDiffableCollectionCellProvider = { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case let item as SPDiffableSideBarItem:
                let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SPDiffableSideBarItem> { (cell, indexPath, item) in
                    var content = UIListContentConfiguration.sidebarCell()
                    content.text = item.title
                    content.image = item.image
                    cell.contentConfiguration = content
                    cell.accessories = item.accessories
                }
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            case let item as SPDiffableSideBarButton:
                let cellRegistration = UICollectionView.CellRegistration<SPDiffableSideBarButtonCollectionViewListCell, SPDiffableSideBarButton> { (cell, indexPath, item) in
                    cell.updateWithItem(item)
                    cell.accessories = item.accessories
                }
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            case let item as SPDiffableSideBarHeader:
                let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SPDiffableSideBarHeader> { (cell, indexPath, item) in
                    var content = UIListContentConfiguration.sidebarHeader()
                    content.text = item.text
                    content.image = nil
                    cell.contentConfiguration = content
                    cell.accessories = item.accessories
                }
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            default:
                return nil
            }
        }
        return [cellProvider]
    }
}
