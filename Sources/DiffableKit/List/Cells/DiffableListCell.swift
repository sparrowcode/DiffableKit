import UIKit

/* Ячейка списка для стандартных строк. Повторяет поведение `DiffableTableViewCell`:
 когда сверху модалка и тинт приглушён, картинка строки становится серой. */
open class DiffableListCell: UICollectionViewListCell {

    /* Как `selectionStyle = .none` у ячейки таблицы: нажатие доходит до действия строки,
     но фон не подсвечивается. Запретить подсветку через делегат нельзя: без подсветки
     коллекция не выделяет элемент и действие не вызывается. */
    open var highlightsBackground = true {
        didSet {
            guard highlightsBackground != oldValue else { return }
            setNeedsUpdateConfiguration()
        }
    }

    /* Строка-кнопка: при нажатии приглушается содержимое, а фон не меняется. */
    open var dimsContentOnHighlight = false {
        didSet {
            guard dimsContentOnHighlight != oldValue else { return }
            setNeedsUpdateConfiguration()
        }
    }

    private static let highlightAlpha: CGFloat = 0.6
    private static let highlightAnimationDuration: TimeInterval = 0.15

    private var originalImage: UIImage?

    open override func updateConfiguration(using state: UICellConfigurationState) {
        var backgroundState = state
        if !highlightsBackground || dimsContentOnHighlight {
            backgroundState.isHighlighted = false
            backgroundState.isSelected = false
        }
        super.updateConfiguration(using: backgroundState)

        let alpha: CGFloat = dimsContentOnHighlight && state.isHighlighted ? Self.highlightAlpha : 1
        guard contentView.alpha != alpha else { return }
        if window != nil {
            UIView.animate(withDuration: Self.highlightAnimationDuration) {
                self.contentView.alpha = alpha
            }
        } else {
            contentView.alpha = alpha
        }
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        originalImage = nil
        highlightsBackground = true
        dimsContentOnHighlight = false
        contentView.alpha = 1
        accessories = []
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        /* Символ, как и текст, окрашен тинтом, и под модалкой его приглушает сам UIKit. Растровую
         картинку со своими цветами UIKit не трогает, её обесцвечивает ячейка. Растровая копия
         символа вышла бы чёрной и без его метрики. */
        guard var content = contentConfiguration as? UIListContentConfiguration,
              let image = originalImage ?? content.image,
              !image.isSymbolImage
        else { return }
        if tintAdjustmentMode == .dimmed {
            originalImage = image
            content.image = image.desaturated()
        } else {
            content.image = image
            originalImage = nil
        }
        contentConfiguration = content
    }
}
