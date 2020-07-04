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

open class SPCollectionDiffableDataSource: UICollectionViewDiffableDataSource<SPDiffableSection, SPDiffableItem> {

    public init(collectionView: UICollectionView, cellProviders: [CellProvider]) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            for provider in cellProviders {
                if let cell = provider(collectionView, indexPath, item) {
                    return cell
                }
            }
            return nil
        }
    }
    
    // MARK: Apply Wrappers
    
    public func apply(_ sections: [SPDiffableSection], animating: Bool) {
        var snapshot = SPDiffableSnapshot()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        apply(snapshot, animatingDifferences: animating)
    }
    
    @objc public func apply(_ snapshot: SPDiffableSnapshot, animating: Bool) {
        apply(snapshot, animatingDifferences: animating, completion: nil)
    }
}

public typealias SPDiffableCollectionCellProvider = SPCollectionDiffableDataSource.CellProvider
