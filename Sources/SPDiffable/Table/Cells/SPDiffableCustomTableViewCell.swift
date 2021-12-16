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

open class SPDiffableCustomTableViewCell: UITableViewCell {
    
    public static var reuseIdentifier: String { "SPDiffableCustomTableViewCell" }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        accessoryView = nil
        detailTextLabel?.text = nil
        higlightStyle = .none
    }
    
    open var higlightStyle: HiglightStyle = .none {
        didSet {
            let selectionStyle: UITableViewCell.SelectionStyle = {
                switch higlightStyle {
                case .none: return .none
                case .`default`: return .`default`
                case .content: return .none
                }
            }()
            self.selectionStyle = selectionStyle
        }
    }
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let higlightContent = (higlightStyle == .content)
        if higlightContent {
            [imageView, textLabel, detailTextLabel].forEach({ $0?.alpha = highlighted ? 0.6 : 1 })
        }
    }
    
    // MARK: - Models
    
    public enum HiglightStyle {
        
        case none
        case `default`
        case content
    }
}
