import UIKit

extension UIFont {

    /* Шрифт строки-кнопки. Размер берём при `.large`, масштабирует метрика: только такой шрифт
       следует за размером текста без пересборки ячейки. */
    static var diffableRowButton: UIFont {
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body, compatibleWith: traits)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: .medium)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }
}
