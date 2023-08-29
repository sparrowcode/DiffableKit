import UIKit

open class DiffableTableSubtitleViewCell: UITableViewCell {
    
    public static let reuseIdentifier = "DiffableTableSubtitleViewCell"
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        accessoryView = nil
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
}
