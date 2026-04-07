import UIKit

open class DiffableButtonTableViewCell: DiffableTableViewCell {

    open override class var reuseIdentifier: String { "DiffableButtonTableViewCell" }

    private static let highlightAlpha: CGFloat = 0.6
    private static let highlightAnimationDuration: TimeInterval = 0.15

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(cellStyle: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        guard var content = contentConfiguration as? UIListContentConfiguration else { return }
        content.textProperties.color = tintAdjustmentMode == .dimmed ? .secondaryLabel : tintColor
        contentConfiguration = content
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let alpha: CGFloat = highlighted ? Self.highlightAlpha : 1
        if animated {
            UIView.animate(withDuration: Self.highlightAnimationDuration) {
                self.contentView.subviews.forEach { $0.alpha = alpha }
            }
        } else {
            contentView.subviews.forEach { $0.alpha = alpha }
        }
    }
}
