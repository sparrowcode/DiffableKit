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
 Model good using with `UIStepper` class.
 */
open class SPDiffableTableRowStepper: SPDiffableItem {
    
    /**
     Current value of stepper.
     */
    public var value: Int
    
    /**
     Minimum value which stepper can set.
     */
    public var minimumValue: Int
    
    /**
     Maximum value which stepper can set.
     */
    public var maximumValue: Int
    
    /**
     Title for cell with stepper.
     */
    public var text: String
    
    /**
     Optional image icon for table cell.
     */
    public var icon: UIImage? = nil
    
    /**
     Action called when stepper change value.
     */
    public var action: Action
    
    public init(text: String, icon: UIImage? = nil, value: Int, minimumValue: Int, maximumValue: Int, action: @escaping Action) {
        self.text = text
        self.icon = icon
        self.value = value
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.action = action
        super.init(text)
    }
    
    /**
     Wrapper for action which called when stepper change value.
     
     - Parameter value: Current value of stepper.
     */
    public typealias Action = (_ value: Int) -> Void
}
