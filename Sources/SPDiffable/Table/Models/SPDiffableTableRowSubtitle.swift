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
 SPDiffable: Basic table item model with titles and accessories.
 
 You can set icon and selection style.
 By default if action is nil, selection style set to `.none`.
 If accessory is control, you can find reay-use class for it.
 */
open class SPDiffableTableRowSubtitle: SPDiffableItem {
    
    open var text: String
    open var subtitle: String? = nil
    open var icon: UIImage? = nil
    open var selectionStyle: UITableViewCell.SelectionStyle
    open var accessoryType: UITableViewCell.AccessoryType
    open var action: Action?
    
    public init(identifier: String? = nil, text: String, subtitle: String?, icon: UIImage? = nil, accessoryType: UITableViewCell.AccessoryType = .none, selectionStyle: UITableViewCell.SelectionStyle = .none, action: Action? = nil) {
        self.text = text
        self.subtitle = subtitle
        self.icon = icon
        self.accessoryType = accessoryType
        self.selectionStyle = selectionStyle
        self.action = action
        super.init(identifier: identifier ?? text)
    }
    
    public typealias Action = (_ indexPath: IndexPath) -> Void
}
