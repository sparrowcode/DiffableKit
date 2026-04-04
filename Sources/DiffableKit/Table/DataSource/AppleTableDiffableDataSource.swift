import UIKit

class AppleTableDiffableDataSource: UITableViewDiffableDataSource<String, String> {

    weak var diffableDelegate: DiffableTableDelegate?

    /* Closure для доступа к секции по String ID снапшота.
     Устанавливается из DiffableTableDataSource при инициализации. */
    var sectionForID: ((_ sectionID: String) -> DiffableSection?)?

    override init(tableView: UITableView, cellProvider: @escaping CellProvider) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }

    // MARK: - Header & Footer Titles

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionIDs = snapshot().sectionIdentifiers
        guard section < sectionIDs.count else { return nil }
        guard let diffableSection = sectionForID?(sectionIDs[section]) else { return nil }
        return (diffableSection.header as? DiffableTextHeaderFooter)?.text
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionIDs = snapshot().sectionIdentifiers
        guard section < sectionIDs.count else { return nil }
        guard let diffableSection = sectionForID?(sectionIDs[section]) else { return nil }
        return (diffableSection.footer as? DiffableTextHeaderFooter)?.text
    }

    // MARK: - Wrappers

    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
}
