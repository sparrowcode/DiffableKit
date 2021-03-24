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
 SPDiffable: Model table cell with stepper and action for it.
 
 Steper action pass value in handler.
 */
open class SPDiffableTableRowStepper: SPDiffableItem {
    
    open var stepValue: Double
    open var value: Double
    open var minimumValue: Double
    open var maximumValue: Double
    open var text: String
    open var icon: UIImage? = nil
    open var action: Action
    
    public init(identifier: String? = nil, text: String, icon: UIImage? = nil, stepValue: Double, value: Double, minimumValue: Double, maximumValue: Double, action: @escaping Action) {
        self.text = text
        self.icon = icon
        self.stepValue = stepValue
        self.value = value
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.action = action
        super.init(identifier: identifier ?? text)
    }
    
    public typealias Action = (_ value: Double) -> Void
}
