import UIKit

extension DiffableTableDataSource {

    open class CellProvider {

        open var closure: Closure

        public init(closure: @escaping Closure) {
            self.closure = closure
        }

        public typealias Closure = (_ tableView: UITableView, _ indexPath: IndexPath, _ item: DiffableItem) -> UITableViewCell?

        // MARK: - Ready Use

        public static var `default`: [CellProvider] {
            return [rowDetail, rowSubtitle, button, `switch`, stepper]
        }

        /* Стандартный размер для layout и отображения non-symbol изображений в ячейках.

         Для SF Symbols система автоматически резервирует стандартное место и масштабирует.
         Для любых других UIImage (растровых, из asset catalog, сгенерированных) — нет:
         система берёт intrinsic size картинки, и ячейка растягивается под неё.

         reservedLayoutSize = standardDimension — резервирует место как для SF Symbols,
         обеспечивая стабильную высоту ячеек и выравнивание текста.

         maximumSize = standardDimension — масштабирует изображение пропорционально вниз
         до стандартного размера, если оно больше.

         Рекомендация Apple: WWDC 2020 "Modern cell configuration" (session 10027). */
        private static let standardImageLayoutSize = CGSize(
            width: UIListContentConfiguration.ImageProperties.standardDimension,
            height: UIListContentConfiguration.ImageProperties.standardDimension
        )

        private static func applyImageLayout(_ content: inout UIListContentConfiguration) {
            content.imageProperties.reservedLayoutSize = standardImageLayoutSize
            content.imageProperties.maximumSize = standardImageLayoutSize
        }

        public static var rowDetail: CellProvider {
            return CellProvider { tableView, indexPath, item in
                guard let item = item as? DiffableTableRow else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableTableViewCell.reuseIdentifier, for: indexPath) as! DiffableTableViewCell
                var content = UIListContentConfiguration.valueCell()
                content.text = item.text
                content.secondaryText = item.detail
                content.image = item.icon
                applyImageLayout(&content)
                cell.contentConfiguration = content
                cell.updateImageDimming()
                cell.accessoryType = item.accessoryType
                cell.selectionStyle = item.selectionStyle
                return cell
            }
        }

        public static var rowSubtitle: CellProvider {
            return CellProvider { tableView, indexPath, item in
                guard let item = item as? DiffableTableRowSubtitle else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableSubtitleTableViewCell.reuseIdentifier, for: indexPath) as! DiffableSubtitleTableViewCell
                var content = UIListContentConfiguration.subtitleCell()
                content.text = item.text
                content.secondaryText = item.subtitle
                content.image = item.icon
                applyImageLayout(&content)
                cell.contentConfiguration = content
                cell.updateImageDimming()
                cell.accessoryType = item.accessoryType
                cell.selectionStyle = item.selectionStyle
                return cell
            }
        }

        public static var button: CellProvider {
            return CellProvider { tableView, indexPath, item in
                guard let item = item as? DiffableTableRowButton else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableButtonTableViewCell.reuseIdentifier, for: indexPath) as! DiffableButtonTableViewCell
                var content = UIListContentConfiguration.cell()
                content.text = item.text
                content.secondaryText = item.detail
                content.image = item.icon
                applyImageLayout(&content)
                let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
                content.textProperties.font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: .medium)
                cell.contentConfiguration = content
                cell.updateImageDimming()
                cell.accessoryType = item.accessoryType
                return cell
            }
        }

        public static var `switch`: CellProvider {
            return CellProvider { tableView, indexPath, item in
                guard let item = item as? DiffableTableRowSwitch else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableTableViewCell.reuseIdentifier, for: indexPath) as! DiffableTableViewCell
                var content = UIListContentConfiguration.cell()
                content.text = item.text
                content.image = item.icon
                applyImageLayout(&content)
                cell.contentConfiguration = content
                cell.updateImageDimming()

                if let control = cell.accessoryView as? DiffableSwitch {
                    control.action = item.action
                    control.isOn = item.isOn
                } else {
                    let control = DiffableSwitch(action: item.action)
                    control.isOn = item.isOn
                    cell.accessoryView = control
                }

                cell.selectionStyle = .none
                return cell
            }
        }

        public static var stepper: CellProvider {
            return CellProvider { tableView, indexPath, item in
                guard let item = item as? DiffableTableRowStepper else { return nil }
                let cell = tableView.dequeueReusableCell(withIdentifier: DiffableTableViewCell.reuseIdentifier, for: indexPath) as! DiffableTableViewCell
                var content = UIListContentConfiguration.cell()
                content.text = item.text
                content.image = item.icon
                applyImageLayout(&content)
                cell.contentConfiguration = content
                cell.updateImageDimming()

                if let control = cell.accessoryView as? DiffableStepper {
                    control.action = item.action
                    control.stepValue = item.stepValue
                    control.value = item.value
                    control.minimumValue = item.minimumValue
                    control.maximumValue = item.maximumValue
                } else {
                    let control = DiffableStepper(action: item.action)
                    control.stepValue = item.stepValue
                    control.value = item.value
                    control.minimumValue = item.minimumValue
                    control.maximumValue = item.maximumValue
                    cell.accessoryView = control
                }

                cell.selectionStyle = .none
                return cell
            }
        }
    }
}
