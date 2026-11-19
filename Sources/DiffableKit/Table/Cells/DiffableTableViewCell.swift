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
