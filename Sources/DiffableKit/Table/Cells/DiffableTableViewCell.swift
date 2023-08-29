import UIKit

open class DiffableTableViewCell: UITableViewCell {
    
    public static var reuseIdentifier: String { "DiffableTableViewCell" }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
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
