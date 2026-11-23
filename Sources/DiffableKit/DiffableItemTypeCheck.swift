import Foundation

#if DEBUG
/* Только Debug. Data source переконфигурирует элементы, чей id уже есть в применённом снапшоте,
 а `reconfigureItems` не умеет менять класс ячейки: если под тем же id пришёл элемент другого типа,
 UIKit падает с NSInternalInconsistencyException «Attempted to dequeue a cell for a different
 registration… when reconfiguring an item» уже в глубине apply, без имени элемента.
 Ловим это раньше и падаем с понятным текстом. В Release кода нет вообще.
 https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot/reconfigureitems(_:) */
func assertItemTypesUnchanged(
    _ newItems: [DiffableItem],
    appliedIDs: Set<String>,
    store: [String: DiffableItem],
    dataSource: AnyObject
) {
    for item in newItems where appliedIDs.contains(item.id) {
        guard let old = store[item.id] else { continue }
        let oldType = type(of: old)
        let newType = type(of: item)
        guard oldType != newType else { continue }
        fatalError("""
            \(type(of: dataSource)): id "\(item.id)" changed type from \(oldType) to \(newType) between updates. \
            The item would be reconfigured and UIKit can't change a cell's registration on reconfigure. \
            Give items of different types different ids.
            """)
    }
}
#endif
