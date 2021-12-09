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
public enum SPDiffableTableCellProviders {
    
    /**
     SPDiffable: Return cell providers, which process for project models cells.
     No need additional configure.
     
     For change style of cells requerid register new cell provider.
     */
    public static var `default`: [SPDiffableTableCellProvider] {
        return [rowDetail, rowSubtitle, self.switch, stepper]
    }
    
    public static var rowDetail: SPDiffableTableCellProvider  {
        let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, item) -> UITableViewCell? in
            guard let item = item as? SPDiffableTableRow else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
            cell.textLabel?.text = item.text
            cell.detailTextLabel?.text = item.detail
            cell.imageView?.image = item.icon
            cell.accessoryType = item.accessoryType
            cell.selectionStyle = item.selectionStyle
            return cell
        }
        return cellProvider
    }
    
    public static var rowSubtitle: SPDiffableTableCellProvider  {
        let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, item) -> UITableViewCell? in
            guard let item = item as? SPDiffableTableRowSubtitle else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableSubtitleTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableSubtitleTableViewCell
            cell.textLabel?.text = item.text
            cell.detailTextLabel?.text = item.subtitle
            cell.imageView?.image = item.icon
            cell.accessoryType = item.accessoryType
            cell.selectionStyle = item.selectionStyle
            return cell
        }
        return cellProvider
    }
    
    public static var `switch`: SPDiffableTableCellProvider  {
        let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, item) -> UITableViewCell? in
            guard let item = item as? SPDiffableTableRowSwitch else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
            cell.textLabel?.text = item.text
            let control = SPDiffableSwitch(action: item.action)
            control.isOn = item.isOn
            cell.imageView?.image = item.icon
            cell.accessoryView = control
            cell.selectionStyle = .none
            return cell
        }
        return cellProvider
    }
    
    public static var stepper: SPDiffableTableCellProvider  {
        let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, item) -> UITableViewCell? in
            guard let item = item as? SPDiffableTableRowStepper else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
            cell.textLabel?.text = item.text
            let control = SPDiffableStepper(action: item.action)
            control.stepValue = item.stepValue
            control.value = item.value
            control.minimumValue = item.minimumValue
            control.maximumValue = item.maximumValue
            cell.imageView?.image = item.icon
            cell.accessoryView = control
            cell.selectionStyle = .none
            return cell
        }
        return cellProvider
    }
}
