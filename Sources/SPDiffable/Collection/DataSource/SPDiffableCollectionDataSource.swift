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

/**
 SPDiffable: Diffable collecton data source.
 
 Using array cell providers for get view for each model.
 Need pass all cell providers which will be using in collection view and data source all by order each and try get view.
 */
@available(iOS 13.0, *)
open class SPDiffableCollectionDataSource: UICollectionViewDiffableDataSource<SPDiffableSection, SPDiffableItem> {
    
    /**
     SPDiffable: Make section and use header model like first cell.
     
     If you don't use composition layout, no way say to collection system about header elements. Its using random, sometimes its cell provider call, sometimes it call supplementary. In this case we shoudn't set header to section snapshot. For this case it condition only.
     */
    public let headerAsFirstCell: Bool
    
    /**
     SPDiffable: Mirror of `UICollectionViewDelegate`.
     */
    open weak var diffableDelegate: SPDiffableCollectionDelegate?
    
    // Using for get cells or update its.
    internal weak var collectionView: UICollectionView?
    
    // MARK: - Init
    
    public init(
        collectionView: UICollectionView,
        cellProviders: [SPDiffableCollectionCellProvider],
        headerFooterProviders: [SPDiffableCollectionHeaderFooterProvider] = [],
        headerAsFirstCell: Bool = true
    ) {
        self.headerAsFirstCell = headerAsFirstCell
        self.collectionView = collectionView
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            for provider in cellProviders {
                if let cell = provider.clouser(collectionView, indexPath, item) {
                    return cell
                }
            }
            return nil
        }

        if !headerFooterProviders.isEmpty {
            supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
                for provider in headerFooterProviders {
                    if let view = provider.clouser(collectionView, kind, indexPath) {
                        return view
                    }
                }
                return nil
            }
        }
        
        collectionView.delegate = self
    }
}
