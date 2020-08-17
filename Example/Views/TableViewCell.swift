import UIKit

class TableViewCell: SPDiffableTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryView = nil
    }
}
