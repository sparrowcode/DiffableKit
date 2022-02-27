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

/**
 SPDiffable: Basic class for items and sections.
 
 All next model's classes shoud be extend from it class.
 */
open class SPDiffableItem: NSObject, NSCopying {
    
    /**
     SPDiffable: Identifier help for detect uniq cell and doing diffable work and animations.
     
     Always shoud be uniq. But if it changed, diffable system remove old and insert new (not reload).
     Identifier uses in `Hashable` and `Equatable` protocols.
     */
    open var id: Identifier
    
    // MARK: - Init
    
    public init(id: Identifier) {
        self.id = id
    }
    
    // MARK: - Hashable and Equatable
    
    open override var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? SPDiffableItem else { return false }
        return id == object.id
    }
    
    // MARK: - NSCopying
    
    // Implemented becouse when using with collection,
    // sometimes catch error about unregognized selector.
    open func copy(with zone: NSZone? = nil) -> Any {
        return SPDiffableItem(id: self.id)
    }
    
    // MARK: - Identifier
    
    public typealias Identifier = String
}
