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

@available(iOS 13.0, *)
extension SPDiffableCollectionDataSource {
    
    // MARK: - Apply Content
    
    /**
     SPDiffable: Applying sections to current snapshot.
     
     Section convert to snapshot and appling after.
     If it iOS 14 and higher, content split to section and apply each section to collection.
     If it iOS 13, section convert to snaphost and apply all.
     
     - parameter sections: Array of `SPDiffableSection`, it content of table.
     - parameter animating: Shoud apply changes with animation or not.
     */
    public func apply(_ sections: [SPDiffableSection], animated: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 14, *) {
            
            var snapshot = self.snapshot()
            
            // Delete
            
            let deletedSections = snapshot.sectionIdentifiers.filter({ (checkSection) -> Bool in
                return !sections.contains(where: { $0.id == checkSection.id })
            })
            if !deletedSections.isEmpty {
                snapshot.deleteSections(deletedSections)
            }
            
            // Add
            
            let addedSections = sections.filter { checkSection in
                return !snapshot.sectionIdentifiers.contains(where: {
                    $0.id == checkSection.id
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
                guard let _ = snapshot.sectionIdentifiers.first(where: { $0.id == section.id }) else { continue }
                guard let _ = snapshot.sectionIdentifiers.first(where: { $0.id == previousSection.id }) else { continue }
                snapshot.moveSection(section, afterSection: previousSection)
            }
            
            // Set new header and footer
            
            for checkSection in snapshot.sectionIdentifiers {
                if let newSection = sections.first(where: { $0.id == checkSection.id }) {
                    checkSection.header = newSection.header
                    checkSection.footer = newSection.footer
                }
            }
            
            // Apply Changes
            
            apply(snapshot, animated: true, completion: completion)
            
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
            apply(snapshot, animatingDifferences: animated, completion: completion)
        }
    }
    
    /**
     SPDiffable: Applying new snapshot insted of current.
     
     - parameter snapshot: New snapshot.
     - parameter animating: Shoud apply changes with animation or not.
     */
    public func apply(_ snapshot: SPDiffableSnapshot, animated: Bool, completion: (() -> Void)? = nil) {
        apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    // MARK: - Reload Content
    
    /**
     SPDiffable: Reload current snapshot with new snapshot.
     
     Deep reload like reload data in old way collection view.
     
     - parameter sections: Array of `SPDiffableSection`, it content of table.
     */
    public func reload(_ sections: [SPDiffableSection]) {
        var snapshot = SPDiffableSnapshot()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        reload(snapshot)
    }
    
    /**
     SPDiffable: Reload current snapshot with new snapshot.
     
     Deep reload like reload data in old way collection view.
     
     - parameter snapshot: New snapshot.
     */
    public func reload(_ snapshot: SPDiffableSnapshot) {
        if #available(iOS 15.0, *) {
            applySnapshotUsingReloadData(snapshot, completion: nil)
        } else {
            apply(snapshot, animatingDifferences: false, completion: nil)
        }
    }
    
    /**
     SPDiffable: Update layout.

     - parameter animating: Shoud update layout with animation or not.
     - parameter completion: A closure to execute when the updating complete.
     */
    public func updateLayout(animated: Bool, completion: (() -> Void)? = nil) {
        let snapshot = self.snapshot()
        apply(snapshot, animated: animated, completion: completion)
    }
}