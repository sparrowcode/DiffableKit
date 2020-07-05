// The MIT License (MIT)
// Copyright © 2020 Ivan Vorobei (varabeis@icloud.com)
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

/**
Basic side bar controller.

 For common init call `setCellProviders` with default data and providers for it models.
 If need init manually, shoud init `diffableDataSource` fist, and next apply content when you need it.

 Collection configuration setted to `.sidebar`.
 Layout detect data source and automatically set header and footer mode.
*/
@available(iOS 14, *)
open class SPDiffableSideBarController: UIViewController, UICollectionViewDelegate {
    
    public var collectionView: UICollectionView!
    public var diffableDataSource: SPCollectionDiffableDataSource?
    
    /**
     Init `diffableDataSource` and apply content to data source without animation.
     
     If need custom logic, you can manually init and apply data when you need.
     
     - warning: Changes applied not animatable.
     - parameter providers: Cell Providers with valid order for processing.
     - parameter sections: Content as array of `SPDiffableSection`.
     */
    public func setCellProviders( _ providers: [SPDiffableCollectionCellProvider], sections: [SPDiffableSection]) {
        diffableDataSource = SPCollectionDiffableDataSource(collectionView: collectionView, cellProviders: providers)
        diffableDataSource?.apply(sections: sections, animating: false)
    }
    
    // MARK: Ovveriden Init
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewCompositionalLayout { [weak self] (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            let header = self?.diffableDataSource?.snapshot().sectionIdentifiers[section].header
            configuration.headerMode = (header == nil) ? .none : .firstItemInSection
            let footer = self?.diffableDataSource?.snapshot().sectionIdentifiers[section].footer
            configuration.footerMode = (footer == nil) ? .none : .supplementary
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    /**
     Defaults cell provider, which can help you doing side bar faster.
     You can do your providers and ise its with more flexible.
     */
    public enum CellProvider {
        
        public static var itemCellProvider: SPDiffableCollectionCellProvider {
            let itemCellProvider: SPDiffableCollectionCellProvider = { (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let item = item as? SPDiffableSideBarMenuItem else { return nil }
                let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SPDiffableSideBarMenuItem> { (cell, indexPath, item) in
                    var content = cell.defaultContentConfiguration()
                    content.text = item.title
                    content.image = item.image
                    cell.contentConfiguration = content
                    cell.accessories = item.accessories
                }
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
            return itemCellProvider
        }
        
        public static var headerCellProvider: SPDiffableCollectionCellProvider {
            let headerCellProvider: SPDiffableCollectionCellProvider = { (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let item = item as? SPDiffableSideBarHeader else { return nil }
                let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SPDiffableSideBarHeader> { (cell, indexPath, item) in
                    var content = cell.defaultContentConfiguration()
                    content.text = item.text
                    content.image = nil
                    cell.contentConfiguration = content
                    cell.accessories = item.accessories
                }
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
            return headerCellProvider
        }
    }
}
