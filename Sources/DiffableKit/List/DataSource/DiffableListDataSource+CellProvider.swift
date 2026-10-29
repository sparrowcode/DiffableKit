import UIKit

extension DiffableListDataSource {

    /* Провайдер ячейки списка. Ячейки в коллекции выдаются только через регистрацию, а её нельзя
     создавать внутри cellProvider, поэтому готовые провайдеры создают регистрацию сразу,
     при обращении к `default` или к самому провайдеру — один раз на `configureDiffable`. */
    open class CellProvider {

        open var closure: Closure

        public init(closure: @escaping Closure) {
            self.closure = closure
        }

        public typealias Closure = @MainActor (_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: DiffableItem) -> UICollectionViewCell?

        // MARK: - Ready Use

        @MainActor
        public static var `default`: [CellProvider] {
            return [rowDetail, rowSubtitle, button, `switch`, stepper]
        }

        @MainActor
        public static var rowDetail: CellProvider {
            let registration = UICollectionView.CellRegistration<DiffableListCell, DiffableTableRow> { cell, _, item in
                var content = UIListContentConfiguration.valueCell()
                content.text = item.text
                content.secondaryText = item.detail
                content.image = item.icon
                content.applyDiffableImageLayout()
                cell.contentConfiguration = content
                cell.accessories = item.accessoryType.listAccessories
                cell.highlightsBackground = item.selectionStyle != .none
            }
            return CellProvider { collectionView, indexPath, item in
                guard let item = item as? DiffableTableRow else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            }
        }

        @MainActor
        public static var rowSubtitle: CellProvider {
            let registration = UICollectionView.CellRegistration<DiffableListCell, DiffableTableRowSubtitle> { cell, _, item in
                var content = UIListContentConfiguration.subtitleCell()
                content.text = item.text
                content.secondaryText = item.subtitle
                content.image = item.icon
                content.applyDiffableImageLayout()
                cell.contentConfiguration = content
                cell.accessories = item.accessoryType.listAccessories
                cell.highlightsBackground = item.selectionStyle != .none
            }
            return CellProvider { collectionView, indexPath, item in
                guard let item = item as? DiffableTableRowSubtitle else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            }
        }

        /* Текст цвета тинта: `UIColor.tintColor` сам становится серым, когда тинт приглушён. */
        @MainActor
        public static var button: CellProvider {
            let registration = UICollectionView.CellRegistration<DiffableListCell, DiffableTableRowButton> { cell, _, item in
                var content = UIListContentConfiguration.cell()
                content.text = item.text
                content.secondaryText = item.detail
                content.image = item.icon
                content.applyDiffableImageLayout()
                let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
                content.textProperties.font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: .medium)
                content.textProperties.color = .tintColor
                cell.contentConfiguration = content
                cell.accessories = item.accessoryType.listAccessories
                cell.dimsContentOnHighlight = true
            }
            return CellProvider { collectionView, indexPath, item in
                guard let item = item as? DiffableTableRowButton else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            }
        }

        @MainActor
        public static var `switch`: CellProvider {
            let registration = UICollectionView.CellRegistration<DiffableListControlCell<DiffableSwitch>, DiffableTableRowSwitch> { cell, _, item in
                var content = UIListContentConfiguration.cell()
                content.text = item.text
                content.image = item.icon
                content.applyDiffableImageLayout()
                cell.contentConfiguration = content
                let control = cell.control { DiffableSwitch(action: item.action) }
                cell.highlightsBackground = false
                control.action = item.action
                control.isOn = item.isOn
            }
            return CellProvider { collectionView, indexPath, item in
                guard let item = item as? DiffableTableRowSwitch else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            }
        }

        @MainActor
        public static var stepper: CellProvider {
            let registration = UICollectionView.CellRegistration<DiffableListControlCell<DiffableStepper>, DiffableTableRowStepper> { cell, _, item in
                var content = UIListContentConfiguration.cell()
                content.text = item.text
                content.image = item.icon
                content.applyDiffableImageLayout()
                cell.contentConfiguration = content
                let control = cell.control { DiffableStepper(action: item.action) }
                cell.highlightsBackground = false
                control.action = item.action
                control.stepValue = item.stepValue
                control.minimumValue = item.minimumValue
                control.maximumValue = item.maximumValue
                control.value = item.value
            }
            return CellProvider { collectionView, indexPath, item in
                guard let item = item as? DiffableTableRowStepper else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            }
        }
    }
}

// MARK: - DiffableListControlCell

/* Ячейка с контролом справа (`.customView`-аксессуар). Контрол создаётся один раз и живёт
 с ячейкой, при переиспользовании меняются только его значения и действие. Строка с контролом
 не выделяется, поэтому и фон не подсвечивается. */
final class DiffableListControlCell<Control: UIControl>: DiffableListCell {

    private var controlView: Control?

    func control(_ make: () -> Control) -> Control {
        if let controlView { return controlView }
        let control = make()
        controlView = control
        accessories = [Self.accessory(for: control)]
        return control
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if let controlView {
            accessories = [Self.accessory(for: controlView)]
        }
    }

    private static func accessory(for control: Control) -> UICellAccessory {
        .customView(configuration: .init(customView: control, placement: .trailing(displayed: .always), reservedLayoutWidth: .actual))
    }
}

// MARK: - Helpers

extension UIListContentConfiguration {

    /* Размер под картинку как у SF Symbols для любых картинок: высота строк и начало текста
     не зависят от того, символ это или растровая иконка. Так же делают провайдеры таблицы.
     WWDC 2020 "Modern cell configuration" (session 10027). */
    mutating func applyDiffableImageLayout() {
        let size = CGSize(
            width: ImageProperties.standardDimension,
            height: ImageProperties.standardDimension
        )
        imageProperties.reservedLayoutSize = size
        imageProperties.maximumSize = size
    }
}

extension UITableViewCell.AccessoryType {

    /* Аксессуар таблицы из модели строки в аксессуары ячейки списка. Кнопка «i» в списке есть
     с iOS 15.4, раньше строка показывается без неё. */
    @MainActor
    var listAccessories: [UICellAccessory] {
        switch self {
        case .disclosureIndicator:
            return [.disclosureIndicator()]
        case .checkmark:
            return [.checkmark()]
        case .detailButton:
            guard #available(iOS 15.4, *) else { return [] }
            return [.detail()]
        case .detailDisclosureButton:
            guard #available(iOS 15.4, *) else { return [.disclosureIndicator()] }
            return [.detail(), .disclosureIndicator()]
        default:
            return []
        }
    }
}
