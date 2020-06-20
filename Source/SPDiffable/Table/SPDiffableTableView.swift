// The MIT License (MIT)
// Copyright © 2020 Ivan Varabei (varabeis@icloud.com)
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
 `SPDiffableTableView` is basic class, which stored and managment diffable data source object.
 
 For set or update data, need pass all cell providers, which processing for each section and item in your data. For apply data, need call `apply` method and pass `SPDiffableSection` objects.
 */
open class SPDiffableTableView: UITableView, UITableViewDelegate {
    
    public var diffableDataSource: SPTableDiffableDataSource!
    
    /**
     Requerid cell providers.
     
     - parameter style: Table style.
     - parameter cellProviders: Functions, whuch process each model to `UITableViewCell`.
     */
    public init(style: UITableView.Style, cellProviders: [SPTableDiffableDataSource.CellProvider]) {
        super.init(frame: .zero, style: style)
        diffableDataSource = SPTableDiffableDataSource(tableView: self, cellProviders: cellProviders)
        delaysContentTouches = false
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
