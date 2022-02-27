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
 SPDiffable: Basic section class. Can set header, footer and items in it section.
 
 Using in diffable work. All sections shoud be inhert from it.
 Can init with empty models if need configure later.
 */
open class SPDiffableSection: NSObject, NSCopying {
    
    /**
     SPDiffable: Identifier help for detect uniq section and doing diffable work and animations.
     
     Always shoud be uniq. But if it changed, diffable system remove old and insert new (not reload).
     Identifier uses in `Hashable` and `Equatable` protocols.
     */
    open var id: SectionIdentifier
    
    open var header: SPDiffableItem?
    open var footer: SPDiffableItem?

    open var items: [SPDiffableItem]
    
    // MARK: - Init
    
    public init(id: SectionIdentifier, header: SPDiffableItem? = nil, footer: SPDiffableItem? = nil, items: [SPDiffableItem] = []) {
        self.id = id
        self.header = header
        self.footer = footer
        self.items = items
    }
    
    // MARK: - Hashable and Equatable
    
    open override var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? SPDiffableSection else { return false }
        return id == object.id
    }
    
    // MARK: - NSCopying
    
    // Implemented becouse when using with collection,
    // sometimes catch error about unregognized selector.
    open func copy(with zone: NSZone? = nil) -> Any {
        return SPDiffableSection(
            id: self.id,
            header: self.header,
            footer: self.footer,
            items: self.items
        )
    }
    
    // MARK: - Item Identifier
    
    public typealias SectionIdentifier = String
}
