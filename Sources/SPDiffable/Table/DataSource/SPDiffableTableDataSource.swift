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
 SPDiffable: Diffable table data source.
 
 Using array cell providers for get view for each model.
 Need pass all cell providers which will be using in collection view and data source all by order each and try get view.
 */
@available(iOS 13.0, *)
open class SPDiffableTableDataSource: UITableViewDiffableDataSource<SPDiffableSection, SPDiffableItem> {
    
    /**
     SPDiffable: Mediator call some methods which can not using in data source object.
     
     Need set mediator for data source and implement methods which need.
     It allow manage for example header titles not ovveride data source class.
     Now data source doing only cell provider logic.
     */
    public weak var mediator: SPDiffableTableMediator?
    
    // Using for get cells or update its.
    internal weak var tableView: UITableView?
    
    // MARK: - Init
    
    public init(tableView: UITableView, cellProviders: [SPDiffableTableCellProvider]) {
        self.tableView = tableView
        super.init(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            for provider in cellProviders {
                if let cell = provider.clouser(tableView, indexPath, item) {
                    return cell
                }
            }
            return nil
        })
    }
    
    // MARK: - Mediator
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let title = mediator?.diffableTableView?(tableView, titleForHeaderInSection: section) {
            return title
        }
        if let header = snapshot().sectionIdentifiers[section].header as? SPDiffableTextHeaderFooter {
            return header.text
        }
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let title = mediator?.diffableTableView?(tableView, titleForFooterInSection: section) {
            return title
        }
        if let footer = snapshot().sectionIdentifiers[section].footer as? SPDiffableTextHeaderFooter {
            return footer.text
        }
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return mediator?.diffableTableView?(tableView, canEditRowAt: indexPath) ?? false
    }
    
    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        mediator?.diffableTableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    open override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return mediator?.diffableTableView?(tableView, canMoveRowAt: indexPath) ?? false
    }
    
    open override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        mediator?.diffableTableView?(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}
