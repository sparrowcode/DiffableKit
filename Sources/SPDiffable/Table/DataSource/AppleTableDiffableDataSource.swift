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
class AppleTableDiffableDataSource: UITableViewDiffableDataSource<SPDiffableSection, SPDiffableItem> {
    
    weak var mediator: SPDiffableTableMediator?
    
    // MARK: - Init
    
    override init(
        tableView: UITableView,
        cellProvider: @escaping CellProvider
    ) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    // MARK: - Mediator
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let header = snapshot().sectionIdentifiers[section].header as? SPDiffableTextHeaderFooter {
            return header.text
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let footer = snapshot().sectionIdentifiers[section].footer as? SPDiffableTextHeaderFooter {
            return footer.text
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return mediator?.diffableTableView?(tableView, canEditRowAt: indexPath) ?? false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        mediator?.diffableTableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return mediator?.diffableTableView?(tableView, canMoveRowAt: indexPath) ?? false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        mediator?.diffableTableView?(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: - Wrappers
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SPDiffableSection, SPDiffableItem>
}
