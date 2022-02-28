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

open class SPDiffableTableRowTextFieldTitle: SPDiffableTableRowTextField {
    
    open var title: String
    
    public init(
        id: String,
        icon: UIImage? = nil,
        title: String,
        text: String?,
        placeholder: String,
        autocorrectionType: UITextAutocorrectionType,
        keyboardType: UIKeyboardType,
        autocapitalizationType: UITextAutocapitalizationType,
        clearButtonMode: UITextField.ViewMode,
        delegate: UITextFieldDelegate?,
        editable: Bool = true
    ) {
        self.title = title
        super.init(id: id, icon: icon, text: text, placeholder: placeholder, autocorrectionType: autocorrectionType, keyboardType: keyboardType, autocapitalizationType: autocapitalizationType, clearButtonMode: clearButtonMode, delegate: delegate, editable: editable)
    }
}
