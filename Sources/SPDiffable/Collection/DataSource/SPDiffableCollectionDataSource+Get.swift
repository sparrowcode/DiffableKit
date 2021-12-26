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

@available(iOS 13.0, *)
extension SPDiffableCollectionDataSource {
    
    /**
     SPDiffable: Get item by index path.
     */
    public func item(for indexPath: IndexPath) -> SPDiffableItem? {
        return itemIdentifier(for: indexPath)
    }
    
    /**
     SPDiffable: Get sections.
     */
    public func sections() -> [SPDiffableSection] {
        return snapshot().sectionIdentifiers
    }
    
    /**
     SPDiffable: Get section by index.
     */
    public func section(for index: Int) -> SPDiffableSection? {
        let snapshot = snapshot()
        guard index < snapshot.sectionIdentifiers.count else { return nil }
        return snapshot.sectionIdentifiers[index]
    }
    
    /**
     SPDiffable: Get index path for item by identifier.
     */
    public func indexPath(for itemID: SPDiffableItem.Identifier) -> IndexPath? {
        return indexPath(for: SPDiffableItem(id: itemID))
    }
    
    /**
     SPDiffable: Get cell specific type `T` by indetifier.
     */
    public func cell<T: UICollectionViewCell>(_ type: T.Type, for itemID: SPDiffableItem.Identifier) -> T? {
        guard let indexPath = indexPath(for: itemID) else { return nil }
        guard let cell = self.collectionView?.cellForItem(at: indexPath) as? T else { return nil }
        return cell
    }
}
