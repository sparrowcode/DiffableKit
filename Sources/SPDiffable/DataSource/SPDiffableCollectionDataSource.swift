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
    public func apply(_ sections: [SPDiffableSection], animated: Bool) {
        if #available(iOS 14, *) {
            
            // Remove section if it deleted from content.
            
            var snapshot = self.snapshot()
            let deletedSections = snapshot.sectionIdentifiers.filter({ (checkSection) -> Bool in
                return !sections.contains(where: { $0.identifier == checkSection.identifier })
            })
            if !deletedSections.isEmpty {
                snapshot.deleteSections(deletedSections)
                apply(snapshot, animated: true)
            }
            
            // Update current sections.
            
            for section in sections {
                var sectionSnapshot = SPDiffableSectionSnapshot()
                let header = section.header
                if let header = header {
                    sectionSnapshot.append([header])
                }
                sectionSnapshot.append(section.items, to: header)
                sectionSnapshot.expand(sectionSnapshot.items)
                apply(sectionSnapshot, to: section, animatingDifferences: animated)
            }
        } else {
            var snapshot = SPDiffableSnapshot()
            snapshot.appendSections(sections)
            for section in sections {
                snapshot.appendItems(section.items, toSection: section)
            }
            apply(snapshot, animatingDifferences: animated)
        }
    }
    
    /**
     Applying new snapshot insted of current.
     
     - parameter snapshot: New snapshot.
     - parameter animating: Shoud apply changes with animation or not.
     */
    public func apply(_ snapshot: SPDiffableSnapshot, animated: Bool) {
        apply(snapshot, animatingDifferences: animated, completion: nil)
    }
}

/**
 Wrapper of collection cell provider.
 */
@available(iOS 13.0, *)
public typealias SPDiffableCollectionCellProvider = SPDiffableCollectionDataSource.CellProvider
