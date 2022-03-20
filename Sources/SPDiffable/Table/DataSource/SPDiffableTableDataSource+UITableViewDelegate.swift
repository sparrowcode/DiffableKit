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
extension SPDiffableTableDataSource: UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = getItem(indexPath: indexPath) else { return }
        diffableDelegate?.diffableTableView?(tableView, didSelectItem: item, indexPath: indexPath)
        
        switch item {
        case let model as SPDiffableItemActionable:
            model.action?(item, indexPath)
        default:
            break
        }
    }
    
    #if canImport(UIKit) && (os(iOS))
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableTableView?(tableView, leadingSwipeActionsConfigurationForItem: item, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableTableView?(tableView, trailingSwipeActionsConfigurationForItem: item, at: indexPath)
    }
    #endif
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = self.getSection(index: section)?.header else { return nil }
        for provider in headerFooterProviders {
            if let view = provider.clouser(tableView, section, item) {
                return view
            }
        }
        return nil
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = self.getSection(index: section)?.footer else { return nil }
        for provider in headerFooterProviders {
            if let view = provider.clouser(tableView, section, item) {
                return view
            }
        }
        return nil
    }
}
