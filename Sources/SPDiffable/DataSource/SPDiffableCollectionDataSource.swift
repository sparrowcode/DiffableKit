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
    
    private weak var collectionView: UICollectionView?
    
    /**
     SPDiffable: Make section and use header model like first cell.
     
     If you don't use composition layout, no way say to collection system about header elements. Its using random, sometimes its cell provider call, sometimes it call supplementary. In this case we shoudn't set header to section snapshot. For this case it condition only.
     */
    public let headerAsFirstCell: Bool
    
    // MARK: - Init
    
    public init(collectionView: UICollectionView, cellProviders: [CellProvider], supplementaryViewProviders: [SupplementaryViewProvider] = [], headerAsFirstCell: Bool = true) {
        
        self.headerAsFirstCell = headerAsFirstCell
        self.collectionView = collectionView
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            for provider in cellProviders {
                if let cell = provider(collectionView, indexPath, item) {
                    return cell
                }
            }
            return nil
        }
        
        if !supplementaryViewProviders.isEmpty {
            supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
                for provider in supplementaryViewProviders {
                    if let view = provider(collectionView, kind, indexPath) {
                        return view
                    }
                }
                return nil
            }
        }
    }
    
    // MARK: - Apply Content
    
    /**
     SPDiffable: Applying sections to current snapshot.
     
     Section convert to snapshot and appling after.
     If it iOS 14 and higher, content split to section and apply each section to collection.
     If it iOS 13, section convert to snaphost and apply all.
     
     - parameter sections: Array of `SPDiffableSection`, it content of table.
     - parameter animating: Shoud apply changes with animation or not.
     */
    public func apply(_ sections: [SPDiffableSection], animated: Bool) {
        if #available(iOS 14, *) {
            
            var snapshot = self.snapshot()
            
            // Delete
            
            let deletedSections = snapshot.sectionIdentifiers.filter({ (checkSection) -> Bool in
                return !sections.contains(where: { $0.identifier == checkSection.identifier })
            })
            if !deletedSections.isEmpty {
                snapshot.deleteSections(deletedSections)
            }
            
            // Add
            
            let addedSections = sections.filter { checkSection in
                return !snapshot.sectionIdentifiers.contains(where: {
                    $0.identifier == checkSection.identifier
                })
            }
            if !addedSections.isEmpty {
                snapshot.appendSections(addedSections)
            }
            
            // Reoder

            for (sectionIndex, section) in sections.enumerated() {
                let previousSectionIndex = sectionIndex - 1
                guard (sections.count > previousSectionIndex) && (previousSectionIndex >= 0) else { continue }
                let previousSection = sections[previousSectionIndex]
                guard let _ = snapshot.sectionIdentifiers.first(where: { $0.identifier == section.identifier }) else { continue }
                guard let _ = snapshot.sectionIdentifiers.first(where: { $0.identifier == previousSection.identifier }) else { continue }
                snapshot.moveSection(section, afterSection: previousSection)
            }
            
            // Set new header and footer
            
            for checkSection in snapshot.sectionIdentifiers {
                if let newSection = sections.first(where: { $0.identifier == checkSection.identifier }) {
                    checkSection.header = newSection.header
                    checkSection.footer = newSection.footer
                }
            }
            
            // Apply Changes
            
            apply(snapshot, animated: true)
            
            // Update items in Sections
    
            for section in sections {
                var sectionSnapshot = SPDiffableSectionSnapshot()
                
                if headerAsFirstCell {
                    let header = section.header
                    if let header = header {
                        sectionSnapshot.append([header])
                    }
                    sectionSnapshot.append(section.items, to: header)
                } else {
                    sectionSnapshot.append(section.items)
                }
                
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
     SPDiffable: Applying new snapshot insted of current.
     
     - parameter snapshot: New snapshot.
     - parameter animating: Shoud apply changes with animation or not.
     */
    public func apply(_ snapshot: SPDiffableSnapshot, animated: Bool) {
        apply(snapshot, animatingDifferences: animated, completion: nil)
    }
    
    // MARK: - Get Content
    
    /**
     SPDiffable: Get item by index path.
     */
    public func item(for indexPath: IndexPath) -> SPDiffableItem? {
        return itemIdentifier(for: indexPath)
    }
    
    /**
     SPDiffable: Get sections.
     */
    public func sections() -> [SPDiffableSection] {
        return snapshot().sectionIdentifiers
    }
    
    /**
     SPDiffable: Get section by index.
     */
    public func section(for index: Int) -> SPDiffableSection? {
        let snapshot = snapshot()
        guard index < snapshot.sectionIdentifiers.count else { return nil }
        return snapshot.sectionIdentifiers[index]
    }
    
    /**
     SPDiffable: Get index path for item by identifier.
     */
    public func indexPath(for itemIdentifier: SPDiffableItem.Identifier) -> IndexPath? {
        return indexPath(for: SPDiffableItem(identifier: itemIdentifier))
    }
    
    /**
     SPDiffable: Get cell specific type `T` by indetifier.
     */
    public func cell<T: UICollectionViewCell>(_ type: T.Type, for itemIdentifier: SPDiffableItem.Identifier) -> T? {
        guard let indexPath = indexPath(for: itemIdentifier) else { return nil }
        guard let cell = self.collectionView?.cellForItem(at: indexPath) as? T else { return nil }
        return cell
    }
}

/**
 SPDiffable: Wrapper of collection cell provider.
 */
@available(iOS 13.0, *)
public typealias SPDiffableCollectionCellProvider = SPDiffableCollectionDataSource.CellProvider

/**
 SPDiffable: Wrapper of collection supplementary view provider.
 */
@available(iOS 13.0, *)
public typealias SPDiffableCollectionSupplementaryViewProvider = SPDiffableCollectionDataSource.SupplementaryViewProvider
