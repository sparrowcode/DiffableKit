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
extension SPDiffableTableDataSource {
    
    
    // MARK: - Apply Content
    
    /**
     SPDiffable: Applying sections to current snapshot.
     
     Section convert to snapshot and appling after.
     
     - parameter sections: Array of `SPDiffableSection`, it content of table.
     - parameter animating: Shoud apply changes with animation or not.
     - parameter completion: A closure to execute when the animations are complete.
     */
    public func apply(_ sections: [SPDiffableSection], animated: Bool, completion: (() -> Void)? = nil) {
        let snapshot = convertToSnapshot(sections)
        apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    /**
     SPDiffable: Applying new snapshot insted of current.
     
     - parameter snapshot: New snapshot.
     - parameter animating: Shoud apply changes with animation or not.
     - parameter completion: A closure to execute when the animations are complete.
     */
    public func apply(_ snapshot: SPDiffableSnapshot, animated: Bool, completion: (() -> Void)? = nil) {
        apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    // MARK: - Reload Content
    
    /**
     SPDiffable: Reload current snapshot with new snapshot.
     
     Deep reload like reload data in old way table view.
     
     - parameter sections: Array of `SPDiffableSection`, it content of table.
     */
    public func reload(_ sections: [SPDiffableSection]) {
        let snapshot = convertToSnapshot(sections)
        reload(snapshot)
    }
    
    /**
     SPDiffable: Reload current snapshot with new snapshot.
     
     Deep reload like reload data in old way table view.
     
     - parameter snapshot: New snapshot.
     */
    public func reload(_ snapshot: SPDiffableSnapshot) {
        if #available(iOS 15.0, *) {
            applySnapshotUsingReloadData(snapshot, completion: nil)
        } else {
            apply(snapshot, animatingDifferences: false, completion: nil)
        }
    }
    
    /**
     SPDiffable: Reload one cell by item.
     
     - parameter item: Reloading item.
     */
    public func reload(_ item: SPDiffableItem) {
        reload([item])
    }
    
    /**
     SPDiffable: Reload cells by items.
     
     - parameter items: Reloading items.
     */
    public func reload(_ items: [SPDiffableItem]) {
        var snapshot = self.snapshot()
        if #available(iOS 15.0, *) {
            snapshot.reconfigureItems(items)
            apply(snapshot)
        } else {
            snapshot.reloadItems(items)
        }
    }
    
    /**
     SPDiffable: Update layout.

     - parameter animating: Shoud update layout with animation or not.
     - parameter completion: A closure to execute when the updating complete.
     */
    public func updateLayout(animated: Bool, completion: (() -> Void)? = nil) {
        let snapshot = self.snapshot()
        apply(snapshot, animated: animated, completion: completion)
    }
}
