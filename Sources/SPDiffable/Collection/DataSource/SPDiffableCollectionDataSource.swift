// The MIT License (MIT)
// Copyright © 2020 Ivan Vorobei (hello@ivanvorobei.io)
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

@available(iOS 13.0, tvOS 13, *)
open class SPDiffableCollectionDataSource: NSObject, SPDiffableDataSourceInterface {
    
    open weak var diffableDelegate: SPDiffableCollectionDelegate?
    
    internal let headerAsFirstCell: Bool
    internal weak var collectionView: UICollectionView?
    internal var sections: [SPDiffableSection]
    
    private var appleDiffableDataSource: AppleCollectionDiffableDataSource?
    
    public init(
        collectionView: UICollectionView,
        cellProviders: [CellProvider],
        headerFooterProviders: [HeaderFooterProvider],
        headerAsFirstCell: Bool
    ) {
        
        self.headerAsFirstCell = headerAsFirstCell
        self.collectionView = collectionView
        self.sections = []
        
        super.init()
        
        self.collectionView?.delegate = self
        
        self.appleDiffableDataSource = .init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                for provider in cellProviders {
                    let itemID = itemIdentifier.id
                    let item: SPDiffableItem? = {
                        if indexPath.row == .zero && headerAsFirstCell {
                            let section = self.sections[indexPath.section]
                            return section.header ?? self.getItem(id: itemID)
                        } else {
                            return self.getItem(id: itemID)
                        }
                    }()
                    guard let item = item else { continue }
                    if let cell = provider.clouser(collectionView, indexPath, item) {
                        return cell
                    }
                }
                return nil
            },
            headerFooterProvider: { collectionView, elementKind, indexPath in
                for provider in headerFooterProviders {
                    let sectionIndex = indexPath.section
                    let section = self.sections[sectionIndex]
                    switch elementKind {
                    case UICollectionView.elementKindSectionHeader:
                        guard let headerItem = section.header else { continue }
                        if let view = provider.clouser(collectionView, elementKind, indexPath, headerItem) {
                            return view
                        }
                    case UICollectionView.elementKindSectionFooter:
                        guard let footerItem = section.footer else { continue }
                        if let view = provider.clouser(collectionView, elementKind, indexPath, footerItem) {
                            return view
                        }
                    default:
                        return nil
                    }
                }
                return nil
            }
        )
    }
    
    // MARK: - Configure
    
    public func set(_ sections: [SPDiffableSection], animated: Bool, completion: (() -> Void)? = nil) {
        
        // Update content
        
        self.sections = sections
        
        // Add, remove or reoder
        
        let snapshot = convertToSnapshot(sections)
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: true, completion: completion)
        
        // Update items in Sections
        
        if #available(iOS 14.0, tvOS 14, *) {
            for section in sections {
                var sectionSnapshot = AppleCollectionDiffableDataSource.SectionSnapshot()
                
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
                appleDiffableDataSource?.apply(sectionSnapshot, to: section, animatingDifferences: animated)
            }
        }
        
        // Update visible cells
        
        var items: [SPDiffableItem] = []
        let visibleIndexPaths = self.collectionView?.indexPathsForVisibleItems ?? []
        for indexPath in visibleIndexPaths {
            if let item = getItem(indexPath: indexPath) {
                items.append(item)
            }
        }
        
        if !items.isEmpty {
            reconfigure(items)
        }
    }
    
    public func set(_ items: [SPDiffableItem], animated: Bool, completion: (() -> Void)? = nil) {
        
        // Update content
        
        for newItem in items {
            for (sectionIndex, section) in sections.enumerated() {
                if let itemIndex = section.items.firstIndex(where: { $0.id == newItem.id }) {
                    sections[sectionIndex].items[itemIndex] = newItem
                }
            }
        }
        
        // Update snapshot
        
        var snapshot = convertToSnapshot(sections)
        if #available(iOS 15.0, tvOS 15, *) {
            snapshot.reconfigureItems(items)
        } else {
            snapshot.reloadItems(items)
        }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    public func reconfigure(_ items: [SPDiffableItem]) {
        guard var snapshot = appleDiffableDataSource?.snapshot() else { return }
        if #available(iOS 15.0, tvOS 15, *) {
            snapshot.reconfigureItems(items)
        } else {
            snapshot.reloadItems(items)
        }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    public func updateLayout(animated: Bool, completion: (() -> Void)? = nil) {
        guard let snapshot = appleDiffableDataSource?.snapshot() else { return }
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    // MARK: - Get
    
    public func getItem(id: String) -> SPDiffableItem? {
        for section in sections {
            if let item = section.items.first(where: { $0.id == id }) {
                return item
            }
        }
        return nil
    }
    
    public func getItem(indexPath: IndexPath) -> SPDiffableItem? {
        guard let itemID = appleDiffableDataSource?.itemIdentifier(for: indexPath)?.id else { return nil }
        return getItem(id: itemID)
    }
    
    public func getSection(id: String) -> SPDiffableSection? {
        return sections.first(where: { $0.id == id })
    }
    
    public func getSection(index: Int) -> SPDiffableSection? {
        guard let snapshot = appleDiffableDataSource?.snapshot() else { return nil }
        guard index < snapshot.sectionIdentifiers.count else { return nil }
        return snapshot.sectionIdentifiers[index]
    }
    
    // MARK: - Private
    
    private func convertToSnapshot(_ sections: [SPDiffableSection]) -> AppleCollectionDiffableDataSource.Snapshot {
        if #available(iOS 14, *) {
            
            var snapshot = appleDiffableDataSource?.snapshot() ?? AppleCollectionDiffableDataSource.Snapshot()
            
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
                
                // If try move section to same index as original.
                // This line allow skip it action.
                // Can happen crash for collection if doing it.
                if (previousSectionIndex + 1) == sectionIndex { continue }
                
                snapshot.moveSection(section, afterSection: previousSection)
            }
            
            // Set new header and footer
            
            for checkSection in snapshot.sectionIdentifiers {
                if let newSection = sections.first(where: { $0.id == checkSection.id }) {
                    checkSection.header = newSection.header
                    checkSection.footer = newSection.footer
                }
            }
            
            return snapshot
        } else {
            var snapshot = AppleCollectionDiffableDataSource.Snapshot()
            snapshot.appendSections(sections)
            for section in sections {
                snapshot.appendItems(section.items, toSection: section)
            }
            return snapshot
        }
    }
}
