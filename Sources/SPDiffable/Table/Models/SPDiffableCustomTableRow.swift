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
 SPDiffable: Customisable table item model.
 
 You can customise color and font of labels.
 Diffrent way to manage `selectionStyle`, here it called `higlightStyle` and have more styles.
 */
open class SPDiffableCustomTableRow: SPDiffableTableRow {
    
    open var textColor: UIColor?
    open var textFont: UIFont?
    open var higlightStyle: SPDiffableCustomTableViewCell.HiglightStyle
    
    public init(identifier: String? = nil, text: String, textColor: UIColor? = nil, textFont: UIFont? = nil, detail: String? = nil, icon: UIImage? = nil, accessoryType: UITableViewCell.AccessoryType = .none, higlightStyle: SPDiffableCustomTableViewCell.HiglightStyle = .none, action: Action? = nil) {
        
        self.textColor = textColor
        self.textFont = textFont
        self.higlightStyle = higlightStyle
        
        super.init(identifier: identifier, text: text, detail: detail, icon: icon, accessoryType: accessoryType, action: action)
    }
}