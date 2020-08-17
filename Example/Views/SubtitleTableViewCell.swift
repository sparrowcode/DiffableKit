import UIKit

class SubtitleTableViewCell: SPDiffableSubtitleTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryView = nil
    }
}
