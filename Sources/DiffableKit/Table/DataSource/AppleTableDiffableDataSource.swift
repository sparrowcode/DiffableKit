import UIKit

class AppleTableDiffableDataSource: UITableViewDiffableDataSource<DiffableSection, DiffableItem> {
    
    // MARK: - Init
    
    override init(
        tableView: UITableView,
        cellProvider: @escaping CellProvider
    ) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    // MARK: - Wrappers
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<DiffableSection, DiffableItem>
    
    // MARK: - Ovveride
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let header = snapshot().sectionIdentifiers[section].header as? DiffableTextHeaderFooter {
            return header.text
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let footer = snapshot().sectionIdentifiers[section].footer as? DiffableTextHeaderFooter {
            return footer.text
        }
        return nil
    }
    
    #warning("to methods move it")
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
#warning("to methods move it")
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
}
