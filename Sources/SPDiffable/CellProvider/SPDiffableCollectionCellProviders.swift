import UIKit

public enum SPDiffableCollectionCellProviders {
    
    /**
     Defaults cell provider, which can help you doing side bar faster.
     You can do your providers and ise its with more flexible.
     */
    @available(iOS 14, *)
    public static var sideBar: SPDiffableCollectionCellProvider {
        let cellProvider: SPDiffableCollectionCellProvider = { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let providers = [sideBarItem, sideBarButton, sideBarHeader]
            for provider in providers {
                if let cell = provider(collectionView, indexPath, item) {
                    return cell
                }
            }
            return nil
        }
        return cellProvider
    }
    
    @available(iOS 14, *)
    public static var sideBarItem: SPDiffableCollectionCellProvider {
        let cellProvider: SPDiffableCollectionCellProvider = { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let item = item as? SPDiffableSideBarItem else { return nil }
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SPDiffableSideBarItem> { (cell, indexPath, item) in
                var content = UIListContentConfiguration.sidebarCell()
                content.text = item.title
                content.image = item.image
                cell.contentConfiguration = content
                cell.accessories = item.accessories
            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        return cellProvider
    }
    
    @available(iOS 14, *)
    public static var sideBarButton: SPDiffableCollectionCellProvider {
        let cellProvider: SPDiffableCollectionCellProvider = { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let item = item as? SPDiffableSideBarButton else { return nil }
            let cellRegistration = UICollectionView.CellRegistration<SPDiffableSideBarButtonCollectionViewListCell, SPDiffableSideBarButton> { (cell, indexPath, item) in
                cell.updateWithItem(item)
                cell.accessories = item.accessories
            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        return cellProvider
    }
    
    @available(iOS 14, *)
    public static var sideBarHeader: SPDiffableCollectionCellProvider {
        let cellProvider: SPDiffableCollectionCellProvider = { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let item = item as? SPDiffableSideBarHeader else { return nil }
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SPDiffableSideBarHeader> { (cell, indexPath, item) in
                var content = UIListContentConfiguration.sidebarHeader()
                content.text = item.text
                content.image = nil
                cell.contentConfiguration = content
                cell.accessories = item.accessories
            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        return cellProvider
    }
}
