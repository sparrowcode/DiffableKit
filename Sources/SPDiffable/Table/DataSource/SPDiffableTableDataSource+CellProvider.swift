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
extension SPDiffableTableDataSource {
    
    open class CellProvider {
        
        open var clouser: Clouser
        
        public init(clouser: @escaping Clouser) {
            self.clouser = clouser
        }
        
        public typealias Clouser = (_ tableView: UITableView, _ indexPath: IndexPath, _ item: SPDiffableItem) -> UITableViewCell?
        
        // MARK: - Ready Use
        
        
        public static var `default`: [CellProvider]  {
#if os(iOS)
            return [rowDetail, rowSubtitle, `switch`, stepper, textField]
#else
            return [rowDetail, rowSubtitle, textField]
#endif
        }
        
        public static var rowDetail: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                guard let item = item as? SPDiffableTableRow else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
                cell.textLabel?.text = item.text
                cell.detailTextLabel?.text = item.detail
                cell.imageView?.image = item.icon
                cell.accessoryType = item.accessoryType
                cell.selectionStyle = item.selectionStyle
                return cell
            }
        }
        
        public static var rowSubtitle: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                guard let item = item as? SPDiffableTableRowSubtitle else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableSubtitleTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableSubtitleTableViewCell
                cell.textLabel?.text = item.text
                cell.detailTextLabel?.text = item.subtitle
                cell.imageView?.image = item.icon
                cell.accessoryType = item.accessoryType
                cell.selectionStyle = item.selectionStyle
                return cell
            }
        }
        
        #if os(iOS)
        public static var `switch`: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                guard let item = item as? SPDiffableTableRowSwitch else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
                cell.textLabel?.text = item.text
                cell.imageView?.image = item.icon
                
                if let control = cell.accessoryView as? SPDiffableSwitch {
                    control.action = item.action
                    control.isOn = item.isOn
                } else {
                    let control = SPDiffableSwitch(action: item.action)
                    control.isOn = item.isOn
                    cell.accessoryView = control
                }
                
                cell.selectionStyle = .none
                return cell
            }
        }
        #endif
                
        #if os(iOS)
        public static var stepper: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                guard let item = item as? SPDiffableTableRowStepper else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTableViewCell
                cell.textLabel?.text = item.text
                cell.imageView?.image = item.icon
                
                if let control = cell.accessoryView as? SPDiffableStepper {
                    control.action = item.action
                    control.stepValue = item.stepValue
                    control.value = item.value
                    control.minimumValue = item.minimumValue
                    control.maximumValue = item.maximumValue
                } else {
                    let control = SPDiffableStepper(action: item.action)
                    control.stepValue = item.stepValue
                    control.value = item.value
                    control.minimumValue = item.minimumValue
                    control.maximumValue = item.maximumValue
                    cell.accessoryView = control
                }
                
                cell.selectionStyle = .none
                return cell
            }
        }
        #endif
        
        public static var textField: CellProvider  {
            return CellProvider() { (tableView, indexPath, item) -> UITableViewCell? in
                switch item {
                case let item as SPDiffableTableRowTextFieldTitle:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTextFieldTitleTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTextFieldTitleTableViewCell
                    cell.configure(with: item)
                    return cell
                case let item as SPDiffableTableRowTextField :
                    let cell = tableView.dequeueReusableCell(withIdentifier: SPDiffableTextFieldTableViewCell.reuseIdentifier, for: indexPath) as! SPDiffableTextFieldTableViewCell
                    cell.configure(with: item)
                    return cell
                default:
                    return nil
                }
            }
        }
    }
}
