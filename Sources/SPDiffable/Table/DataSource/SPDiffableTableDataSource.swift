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
open class SPDiffableTableDataSource: NSObject, SPDiffableDataSourceInterface {
    
    open weak var mediator: SPDiffableTableMediator? {
        get { appleDiffableDataSource?.mediator }
        set { appleDiffableDataSource?.mediator = newValue }
    }
    
    open weak var diffableDelegate: SPDiffableTableDelegate?
    
    internal weak var tableView: UITableView?
    internal var sections: [SPDiffableSection]
    internal var headerFooterProviders: [HeaderFooterProvider]
    
    private var appleDiffableDataSource: AppleTableDiffableDataSource?
    
    // MARK: - Init
    
    init(
        tableView: UITableView,
        cellProviders: [CellProvider],
        headerFooterProviders: [HeaderFooterProvider]
    ) {
        
        self.tableView = tableView
        self.sections = []
        self.headerFooterProviders = headerFooterProviders
        
        super.init()
        
        self.appleDiffableDataSource = .init(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                for provider in cellProviders {
                    let itemID = itemIdentifier.id
                    guard let item = self.getItem(id: itemID) else { continue }
                    if let cell = provider.clouser(tableView, indexPath, item) {
                        return cell
                    }
                }
                return nil
            }
        )
        
        self.tableView?.delegate = self
    }
    
    // MARK: - Set
    
    public func set(_ sections: [SPDiffableSection], animated: Bool, completion: (() -> Void)? = nil) {
        
        // Update content
        
        self.sections = sections
        
        // Add, remove or reoder
        
        let snapshot = convertToSnapshot(self.sections)
        appleDiffableDataSource?.apply(snapshot, animatingDifferences: animated, completion: completion)
        
        // Update visible cells
        
        var items: [SPDiffableItem] = []
        let visibleIndexPaths = self.tableView?.indexPathsForVisibleRows ?? []
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
    
    public func getIndexPath(id: String) -> IndexPath? {
        guard let item = getItem(id: id) else { return nil }
        guard let indexPath = appleDiffableDataSource?.indexPath(for: item) else { return nil }
        return indexPath
    }
    
    public func getIndexPath(item: SPDiffableItem) -> IndexPath? {
        guard let indexPath = appleDiffableDataSource?.indexPath(for: item) else { return nil }
        return indexPath
    }
    
    // MARK: - Private
    
    private func convertToSnapshot(_ sections: [SPDiffableSection]) -> AppleTableDiffableDataSource.Snapshot {
        var snapshot = AppleTableDiffableDataSource.Snapshot()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        return snapshot
    }
}
