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
 Menu item in side bar.
 
 For header use `SPDiffableSideBarHeader` class.
 */
@available(iOS 14, *)
open class SPDiffableSideBarItem: SPDiffableItem {
    
    public let title: String
    public let image: UIImage?
    public var accessories: [UICellAccessory]
    public var action: Action
    
    public init(identifier: SPDiffableItem.Identifier? = nil, title: String, image: UIImage?, accessories: [UICellAccessory] = [], action: @escaping Action) {
        self.title = title
        self.image = image
        self.accessories = accessories
        self.action = action
        super.init(identifier: identifier ?? title)
    }
    
    public typealias Action = (_ indexPath: IndexPath) -> Void
}
