import UIKit

extension DiffableListDataSource: UICollectionViewDelegate {

    /* Нажимается строка с действием или любая строка, если делегат ловит выбор. Остальные строки
     (поля ввода, переключатели, свои ячейки без действия) не подсвечиваются, как ячейки
     таблицы с `selectionStyle = .none`. */
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let item = getItem(indexPath: indexPath) else { return false }
        if item is DiffableTableRowButton { return true }
        if let actionable = item as? DiffableActionableItem, actionable.action != nil { return true }
        return diffableDelegate?.diffableListView(_:didSelectItem:indexPath:) != nil
    }

    /* Строку без подсветки фона сразу снимаем с выделения: она выделяется только ради действия,
     а повторное нажатие на выделенную строку действие бы не вызвало. */
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = getItem(indexPath: indexPath) else { return }
        if let cell = collectionView.cellForItem(at: indexPath) as? DiffableListCell, !cell.highlightsBackground || cell.dimsContentOnHighlight {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        diffableDelegate?.diffableListView?(collectionView, didSelectItem: item, indexPath: indexPath)

        if let button = item as? DiffableTableRowButton {
            button.action(indexPath)
        } else if let actionable = item as? DiffableActionableItem {
            actionable.action?(item, indexPath)
        }
    }

    // MARK: - Context Menu

    @available(iOS 16.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count == 1, let indexPath = indexPaths.first else { return nil }
        return contextMenuConfiguration(collectionView, indexPath: indexPath, point: point)
    }

    /* До iOS 16 коллекция спрашивает меню этим методом. */
    @available(iOS, introduced: 13.0, deprecated: 16.0)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return contextMenuConfiguration(collectionView, indexPath: indexPath, point: point)
    }

    private func contextMenuConfiguration(_ collectionView: UICollectionView, indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = getItem(indexPath: indexPath) else { return nil }
        return diffableDelegate?.diffableListView?(collectionView, contextMenuConfigurationForItem: item, at: indexPath, point: point)
    }
}
