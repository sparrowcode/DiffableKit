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

open class SPDiffableTextFieldTableViewCell: UITableViewCell {
    
    // MARK: - Data
    
    public static var reuseIdentifier: String { "SPDiffableTextFieldTableViewCell" }
    
    // MARK: - Views
    
    public let textField = UITextField()
    
    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        textField.backgroundColor = .clear
        contentView.addSubview(textField)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        accessoryView = nil
        detailTextLabel?.text = nil
    }
    
    open func configure(with item: SPDiffableTableRowTextField) {
        imageView?.image = item.icon
        textField.text = item.text
        textField.placeholder = item.placeholder
        textField.autocorrectionType = item.autocorrectionType
        textField.keyboardType = item.keyboardType
        textField.autocapitalizationType = item.autocapitalizationType
        textField.delegate = item.delegate
        textField.clearButtonMode = item.clearButtonMode
        accessoryView = .none
        selectionStyle = .none
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = .init(
            x: contentView.layoutMargins.left,
            y: .zero,
            width: contentView.frame.width - contentView.layoutMargins.left - contentView.layoutMargins.right,
            height: contentView.frame.height
        )
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        return .init(width: superSize.width, height: superSize.height + 4)
    }
}
