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
 Diffable collecton data source.
 
 Using array cell providers for get view for each model.
 Need pass all cell providers which will be using in collection view and data source all by order each and try get view.
 */
@available(iOS 13.0, *)
open class SPDiffableCollectionDataSource: UICollectionViewDiffableDataSource<SPDiffableSection, SPDiffableItem> {

    public init(collectionView: UICollectionView, cellProviders: [CellProvider]) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            for provider in cellProviders {
                if let cell = provider(collectionView, indexPath, item) {
                    return cell
                }
            }
            return nil
        }
    }
    
    // MARK: Apply Wrappers
    
    /**
     Applying sections to current snapshot.
     
     Section convert to snapshot and appling after.
     If it iOS 14 and higher, content split to section and apply each section to collection.
     If it iOS 13, section convert to snaphost and apply all.
     
     - parameter sections: Array of `SPDiffableSection`, it content of table.
     - parameter animating: Shoud apply changes with animation or not.
     */
    #warning("trouble with reuse, need fix")
    public func apply(sections: [SPDiffableSection], animating: Bool) {
        var snapshot = SPDiffableSnapshot()
        snapshot.appendSections(sections)
        
        if #available(iOS 14, *) {
            apply(snapshot, animatingDifferences: animating, completion: nil)
            for section in sections {
                var sectionSnapshot = SPDiffableSectionSnapshot()
                if let header = section.header {
                    sectionSnapshot.append([header])
                    sectionSnapshot.append(section.items, to: header)
                    sectionSnapshot.expand(sectionSnapshot.items)
                } else {
                    sectionSnapshot.append(section.items)
                }
                apply(sectionSnapshot, to: section, animatingDifferences: animating)
            }
        } else {
            for section in sections {
                snapshot.appendItems(section.items, toSection: section)
            }
            apply(snapshot, animatingDifferences: animating)
        }
    }
    
    /**
     Applying new snapshot insted of current.
     
     - parameter snapshot: New snapshot.
     - parameter animating: Shoud apply changes with animation or not.
     */
    public func apply(snapshot: SPDiffableSnapshot, animating: Bool) {
        apply(snapshot, animatingDifferences: animating, completion: nil)
    }
}

/**
 Wrapper of collection cell provider.
 */
@available(iOS 13.0, *)
public typealias SPDiffableCollectionCellProvider = SPDiffableCollectionDataSource.CellProvider
