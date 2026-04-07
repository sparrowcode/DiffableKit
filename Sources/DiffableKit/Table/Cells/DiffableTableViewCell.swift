import UIKit

open class DiffableTableViewCell: UITableViewCell {

    open class var reuseIdentifier: String { "DiffableTableViewCell" }

    private var originalImage: UIImage?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    internal init(cellStyle: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: cellStyle, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        originalImage = nil
        contentConfiguration = nil
        accessoryView = nil
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        guard var content = contentConfiguration as? UIListContentConfiguration else { return }
        if tintAdjustmentMode == .dimmed {
            originalImage = content.image
            content.image = originalImage?.desaturated()
        } else if let original = originalImage {
            content.image = original
            originalImage = nil
        }
        contentConfiguration = content
    }
}
