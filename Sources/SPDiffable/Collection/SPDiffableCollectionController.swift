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
 Basic diffable collection controller.
 
 For common init call `setCellProviders` with default data and providers for it models.
 If need init manually, shoud init `diffableDataSource` first, and next apply content when you need it.
 */
@available(iOS 13.0, *)
open class SPDiffableCollectionController: UICollectionViewController {
    
    public var diffableDataSource: SPDiffableCollectionDataSource?
    
    /**
     Init `diffableDataSource` and apply content to data source without animation.
     
     If need custom logic, you can manually init and apply data when you need.
     
     - warning: Changes applied not animatable.
     - parameter providers: Cell Providers with valid order for processing.
     - parameter sections: Content as array of `SPDiffableSection`.
     */
    public func setCellProviders( _ providers: [SPDiffableCollectionCellProvider], sections: [SPDiffableSection]) {
        diffableDataSource = SPDiffableCollectionDataSource(collectionView: collectionView, cellProviders: providers)
        diffableDataSource?.apply(sections, animated: false)
    }
}
