// The MIT License (MIT)
// Copyright © 2020 Ivan Varabei (varabeis@icloud.com)
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

open class SPTableDiffableDataSource: UITableViewDiffableDataSource<SPDiffableSection, SPDiffableItem> {
    
    public weak var diffableDelegate: SPTableDiffableDelegate?
    
    public init(tableView: UITableView, cellProviders: [CellProvider]) {
        super.init(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            for provider in cellProviders {
                if let cell = provider(tableView, indexPath, model) {
                    return cell
                }
            }
            return nil
        })
        defaultRowAnimation = .fade
    }
    
    public func apply(sections: [SPDiffableSection], animating: Bool) {
        var snapshot = SPTableDiffableSnapshot()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        apply(snapshot, animatingDifferences: animating)
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let title = diffableDelegate?.tableView(tableView, titleForHeaderInSection: section) {
            return title
        }
        if let header = snapshot().sectionIdentifiers[section].header as? SPDiffableTextHeader {
            return header.text
        }
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let title = diffableDelegate?.tableView(tableView, titleForFooterInSection: section) {
            return title
        }
        if let footer = snapshot().sectionIdentifiers[section].footer as? SPDiffableTextFooter {
            return footer.text
        }
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return diffableDelegate?.tableView(tableView, canEditRowAt: indexPath) ?? false
    }
}

/**
 Using for apply new data in diffable data source.
 */
typealias SPTableDiffableSnapshot = NSDiffableDataSourceSnapshot<SPDiffableSection, SPDiffableItem>
