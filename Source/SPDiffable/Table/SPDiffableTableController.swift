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
 Basic diffable table controller.
 
 For common init call `setCellProviders` with default data and providers for it models.
 If need init manually, shoud init `diffableDataSource` fist, and next apply content when you need it.
 */
open class SPDiffableTableController: UITableViewController {
    
    public var diffableDataSource: SPDiffableTableDataSource?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SPDiffableTableViewCell.self, forCellReuseIdentifier: SPDiffableTableViewCell.identifier)
        tableView.register(SPDiffableSubtitleTableViewCell.self, forCellReuseIdentifier: SPDiffableSubtitleTableViewCell.identifier)
    }
    
    /**
     Init `diffableDataSource` and apply content to data source without animation.
     
     If need custom logic, you can manually init and apply data when you need.
     
     - warning: Changes applied not animatable.
     - parameter providers: Cell Providers with valid order for processing.
     - parameter sections: Content as array of `SPDiffableSection`.
     */
    public func setCellProviders( _ providers: [SPDiffableTableCellProvider], sections: [SPDiffableSection]) {
        diffableDataSource = SPDiffableTableDataSource(tableView: tableView, cellProviders: providers)
        diffableDataSource?.apply(sections: sections, animating: false)
    }
    
    public static var defaultCellProvider: SPDiffableTableCellProvider {
        let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, model) -> UITableViewCell? in
            switch model {
            case let model as SPDiffableTableRow:
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.identifier, for: indexPath) as! SPDiffableTableViewCell
                cell.textLabel?.text = model.text
                cell.detailTextLabel?.text = model.detail
                     cell.selectionStyle = model.selectionStyle
                return cell
            case let model as SPDiffableTableRowSubtitle:
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableSubtitleTableViewCell.identifier, for: indexPath) as! SPDiffableSubtitleTableViewCell
                cell.textLabel?.text = model.text
                cell.detailTextLabel?.text = model.subtitle
                cell.imageView?.image = model.icon
                cell.accessoryType = model.accessoryType
                cell.selectionStyle = model.selectionStyle
                return cell
            default:
                return nil
            }
        }
        return cellProvider
    }
}
