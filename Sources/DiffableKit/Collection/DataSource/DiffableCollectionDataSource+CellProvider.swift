import UIKit

extension DiffableCollectionDataSource {
    
    open class CellProvider {
        
        open var clouser: Clouser
        
        public init(clouser: @escaping Clouser) {
            self.clouser = clouser
        }
        
        public typealias Clouser = (
            _ collectionView: UICollectionView,
            _ indexPath: IndexPath,
            _ item: DiffableItem
        ) -> UICollectionViewCell?
        
        // MARK: - Ready Use
        
        @available(iOS 14, *)
        public static var sideBarItem: DiffableCollectionDataSource.CellProvider {
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DiffableSideBarItem> { (cell, indexPath, item) in
                
                var content = UIListContentConfiguration.sidebarCell()
                content.text = item.title
                content.image = item.image
                
                switch item.higlight {
                case .bg:
                    break
                case .content:
                    content.textProperties.colorTransformer = UIConfigurationColorTransformer { _ in
                        if cell.isUserInteractionEnabled {
                            return .label.withAlphaComponent(cell.isHighlighted ? 0.5 : 1)
                        } else {
                            return UIColor.systemGray3
                        }
                    }
                    
                    content.imageProperties.tintColorTransformer = UIConfigurationColorTransformer { _ in
                        if cell.isUserInteractionEnabled {
                            if #available(iOS 15.0, *) {
                                return .tintColor.withAlphaComponent(cell.isHighlighted ? 0.5 : 1)
                            } else {
                                return .systemBlue
                            }
                        } else {
                            return UIColor.systemGray3
                        }
                    }
                    
                    var background = UIBackgroundConfiguration.clear()
                    background.strokeColor = .clear
                    background.backgroundColor = .clear
                    cell.backgroundConfiguration = background
                    
                    if #available(iOS 15.0, *) {
                        cell.focusEffect = nil
                    }
                }
                
                cell.contentConfiguration = content
                cell.accessories = item.accessories
                cell.isUserInteractionEnabled = item.isEnabled
            }
            return DiffableCollectionDataSource.CellProvider() { (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let item = item as? DiffableSideBarItem else { return nil }
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
                return cell
            }
        }
        
        @available(iOS 14, *)
        public static var sideBarButton: DiffableCollectionDataSource.CellProvider {
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DiffableSideBarButtonItem> { (cell, indexPath, item) in
                
                var content = UIListContentConfiguration.sidebarCell()
                content.text = item.title
                content.image = item.image
                
                let colorTransformer = UIConfigurationColorTransformer { _ in
                    if cell.isUserInteractionEnabled {
                        if #available(iOS 15.0, *) {
                            return .tintColor.withAlphaComponent(cell.isHighlighted ? 0.5 : 1)
                        } else {
                            return .systemBlue
                        }
                    } else {
                        return UIColor.systemGray3
                    }
                }
                
                content.textProperties.colorTransformer = colorTransformer
                content.imageProperties.tintColorTransformer = colorTransformer
                cell.contentConfiguration = content
                
                var background = UIBackgroundConfiguration.clear()
                background.strokeColor = .clear
                background.backgroundColor = .clear
                cell.backgroundConfiguration = background
                
                cell.accessories = item.accessories
                cell.isUserInteractionEnabled = item.isEnabled
                
                if #available(iOS 15.0, *) {
                    cell.focusEffect = nil
                }
            }
            return DiffableCollectionDataSource.CellProvider() { (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let item = item as? DiffableSideBarButtonItem else { return nil }
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
                return cell
            }
        }
        
        @available(iOS 14, *)
        public static var sideBarHeader: DiffableCollectionDataSource.CellProvider {
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DiffableSideBarHeader> { (cell, indexPath, item) in
                var content = UIListContentConfiguration.sidebarHeader()
                content.text = item.text
                content.image = nil
                cell.contentConfiguration = content
                cell.accessories = item.accessories
            }
            return DiffableCollectionDataSource.CellProvider() { (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let item = item as? DiffableSideBarHeader else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
    }
}
