import UIKit

class DiffableTableController: SPDiffableTableController, SPDiffableTableMediator {
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diffableDataSource?.mediator = self
        setCellProviders([defaultCellProvider], sections: content)
    }
    
    var content: [SPDiffableSection] {
        return []
    }
    
    internal func updateContent(animating: Bool) {
        diffableDataSource?.apply(sections: content, animating: animating)
    }
}
