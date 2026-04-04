import UIKit

open class DiffableSubtitleTableViewCell: DiffableTableViewCell {

    open override class var reuseIdentifier: String { "DiffableSubtitleTableViewCell" }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(cellStyle: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
