import UIKit

/* Переиспользуемая обёртка шапки списка (`DiffableListLayout.headerView`). Шапка одна,
 поэтому её вьюха переезжает в ту обёртку, которую выдал список. Поля обёртки по горизонтали
 совпадают с краями секций: содержимое шапки, привязанное к `layoutMarginsGuide`,
 встаёт ровно над карточками. */
final class DiffableListHeaderContainerView: UICollectionReusableView {

    var hostedView: UIView? {
        didSet {
            guard hostedView !== oldValue else { return }
            if oldValue?.superview === self {
                oldValue?.removeFromSuperview()
            }
            if let hostedView {
                hostedView.translatesAutoresizingMaskIntoConstraints = true
                addSubview(hostedView)
                setNeedsLayout()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        insetsLayoutMarginsFromSafeArea = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        updateMargins()
        super.layoutSubviews()
        hostedView?.frame = bounds
    }

    /* Высота — по содержимому шапки при ширине списка. */
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        guard let hostedView else {
            attributes.size.height = 0
            return attributes
        }
        updateMargins()
        let size = hostedView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.size.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        attributes.size = CGSize(width: layoutAttributes.size.width, height: size.height.rounded(.up))
        return attributes
    }

    private func updateMargins() {
        guard let layout = (superview as? UICollectionView)?.collectionViewLayout.diffableListLayout else { return }
        let insets = layout.sectionHorizontalInsets
        if directionalLayoutMargins.leading != insets.leading || directionalLayoutMargins.trailing != insets.trailing {
            directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: insets.leading, bottom: 0, trailing: insets.trailing)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView = nil
    }
}
