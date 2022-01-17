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
public protocol SPDiffableDataSourceInterface: AnyObject {
    
    // MARK: - Set
    
    func set(_ sections: [SPDiffableSection], animated: Bool, completion: (() -> Void)?)
    func set(_ items: [SPDiffableItem], animated: Bool, completion: (() -> Void)?)
    func reconfigure(_ items: [SPDiffableItem])
    func updateLayout(animated: Bool, completion: (() -> Void)?)
    
    // MARK: - Get
    
    func getItem(id: String) -> SPDiffableItem?
    func getItem(indexPath: IndexPath) -> SPDiffableItem?
    func getSection(id: String) -> SPDiffableSection?
    func getSection(index: Int) -> SPDiffableSection?
}
