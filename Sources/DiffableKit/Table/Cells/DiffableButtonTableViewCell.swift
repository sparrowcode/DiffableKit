import UIKit

open class DiffableButtonTableViewCell: UITableViewCell {

    public static var reuseIdentifier: String { "DiffableButtonTableViewCell" }

    private var originalImage: UIImage?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
        updateDimming()
    }

    func updateDimming() {
        guard var content = contentConfiguration as? UIListContentConfiguration else { return }
        let dimmed = tintAdjustmentMode == .dimmed

        let color: UIColor = dimmed ? .secondaryLabel : tintColor
        if content.textProperties.color != color {
            content.textProperties.color = color
        }

        if let image = content.image {
            if dimmed {
                if image !== originalImage { originalImage = image }
                if let desaturated = originalImage?.desaturated() {
                    content.image = desaturated
                }
            } else if let original = originalImage {
                content.image = original
                originalImage = nil
            }
        }

        contentConfiguration = content
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let alpha: CGFloat = highlighted ? 0.6 : 1
        if animated {
            UIView.animate(withDuration: 0.15) {
                self.contentView.subviews.forEach { $0.alpha = alpha }
            }
        } else {
            contentView.subviews.forEach { $0.alpha = alpha }
        }
    }

}
