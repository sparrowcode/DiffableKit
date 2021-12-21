// The MIT License (MIT)
// Copyright © 2020 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

import UIKit

/**
 SPDiffable: Wrapper of collection cell provider.
 */
@available(iOS 13.0, *)
open class SPDiffableCollectionCellProvider {
    
    open var clouser: SPDiffableCollectionDataSource.CellProvider
    
    public init(clouser: @escaping SPDiffableCollectionDataSource.CellProvider) {
        self.clouser = clouser
    }
    
    // MARK: - Ready Use
    
    /**
     SPDiffable: Defaults cell provider, which can help you doing side bar faster.
     You can do your providers and ise its with more flexible.
     */
    @available(iOS 14, *)
    public static var sideBar: SPDiffableCollectionCellProvider  {
        return SPDiffableCollectionCellProvider() { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let providers = [sideBarItem, sideBarButton, sideBarHeader]
            for provider in providers {
                if let cell = provider.clouser(collectionView, indexPath, item) {
                    return cell
                }
            }
            return nil
        }
    }
    
    @available(iOS 14, *)
    public static var sideBarItem: SPDiffableCollectionCellProvider {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SPDiffableSideBarItem> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.sidebarCell()
            content.text = item.title
            content.image = item.image
            cell.contentConfiguration = content
            cell.accessories = item.accessories
        }
        return SPDiffableCollectionCellProvider() { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let item = item as? SPDiffableSideBarItem else { return nil }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    @available(iOS 14, *)
    public static var sideBarButton: SPDiffableCollectionCellProvider {
        let cellRegistration = UICollectionView.CellRegistration<SPDiffableSideBarButtonCollectionViewListCell, SPDiffableSideBarButton> { (cell, indexPath, item) in
            cell.updateWithItem(item)
            cell.accessories = item.accessories
        }
        return SPDiffableCollectionCellProvider() { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let item = item as? SPDiffableSideBarButton else { return nil }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    @available(iOS 14, *)
    public static var sideBarHeader: SPDiffableCollectionCellProvider {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SPDiffableSideBarHeader> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.sidebarHeader()
            content.text = item.text
            content.image = nil
            cell.contentConfiguration = content
            cell.accessories = item.accessories
        }
        return SPDiffableCollectionCellProvider() { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let item = item as? SPDiffableSideBarHeader else { return nil }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
}
