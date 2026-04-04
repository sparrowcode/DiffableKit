import UIKit

open class DiffableTableViewCell: UITableViewCell {

    public static var reuseIdentifier: String { "DiffableTableViewCell" }

    private var originalImage: UIImage?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
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
        updateImageDimming()
    }

    func updateImageDimming() {
        guard var content = contentConfiguration as? UIListContentConfiguration else { return }
        let dimmed = tintAdjustmentMode == .dimmed
        if dimmed {
            let currentImage = content.image
            if currentImage !== originalImage { originalImage = currentImage }
            guard let desaturated = originalImage?.desaturated() else { return }
            content.image = desaturated
        } else {
            guard let original = originalImage else { return }
            content.image = original
            originalImage = nil
        }
        contentConfiguration = content
    }
}
