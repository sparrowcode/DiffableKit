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

open class SPDiffableTableRowTextField: SPDiffableItem {
    
    open var icon: UIImage?
    open var text: String?
    open var placeholder: String
    open var autocorrectionType: UITextAutocorrectionType
    open var keyboardType: UIKeyboardType
    open var autocapitalizationType: UITextAutocapitalizationType
    open var clearButtonMode: UITextField.ViewMode
    open weak var delegate: UITextFieldDelegate?
    open var editable: Bool
    
    public init(
        id: String,
        icon: UIImage? = nil,
        text: String?,
        placeholder: String,
        autocorrectionType: UITextAutocorrectionType,
        keyboardType: UIKeyboardType,
        autocapitalizationType: UITextAutocapitalizationType,
        clearButtonMode: UITextField.ViewMode,
        delegate: UITextFieldDelegate?,
        editable: Bool = true
    ) {
        self.icon = icon
        self.text = text
        self.placeholder = placeholder
        self.delegate = delegate
        self.autocorrectionType = autocorrectionType
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.clearButtonMode = clearButtonMode
        self.editable = editable
        super.init(id: id)
    }
}
