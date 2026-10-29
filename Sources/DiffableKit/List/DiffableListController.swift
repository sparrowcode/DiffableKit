import UIKit

/* Контроллер со списком на `UICollectionView` — замена `DiffableTableController` с метриками
 системных Настроек. */
open class DiffableListController: UICollectionViewController {

    open var diffableDataSource: DiffableListDataSource?

    public var listLayout: DiffableListLayout {
        collectionViewLayout as! DiffableListLayout
    }

    /* Шапка над списком — замена `tableHeaderView`. */
    open var headerView: UIView? {
        get { listLayout.headerView }
        set { listLayout.headerView = newValue }
    }

    // MARK: - Init

    public init(appearance: UICollectionLayoutListConfiguration.Appearance = .insetGrouped) {
        super.init(collectionViewLayout: DiffableListLayout(appearance: appearance))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false
        collectionView.delaysContentTouches = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectSelectedItems(animated: animated)
    }

    // MARK: - Configure

    open func configureDiffable(
        sections: [DiffableSection],
        cellProviders: [DiffableListDataSource.CellProvider],
        headerFooterProviders: [DiffableListDataSource.HeaderFooterProvider] = []
    ) {
        diffableDataSource = DiffableListDataSource(
            collectionView: collectionView,
            cellProviders: cellProviders,
            headerFooterProviders: headerFooterProviders
        )
        diffableDataSource?.set(sections, animated: false)
    }

    // MARK: - Keyboard

    /* `UITableViewController` сам поднимает содержимое над клавиатурой, а `UICollectionViewController` —
     нет. Нижний отступ списка растёт на ту часть клавиатуры, что закрывает список, и строки
     под клавиатурой можно докрутить. */
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let window = view.window,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardFrameInView = view.convert(keyboardFrame, from: window.screen.coordinateSpace)
        let overlap = max(0, view.bounds.maxY - keyboardFrameInView.minY - view.safeAreaInsets.bottom)
        guard collectionView.contentInset.bottom != overlap else { return }
        collectionView.contentInset.bottom = overlap
        collectionView.verticalScrollIndicatorInsets.bottom = overlap
    }

    // MARK: - Selection

    /* Как у `UITableViewController`: при возврате на экран выделение снимается вместе с переходом,
     а если свайп назад отменили — возвращается. */
    private func deselectSelectedItems(animated: Bool) {
        guard let indexPaths = collectionView.indexPathsForSelectedItems, !indexPaths.isEmpty else { return }
        guard animated, let coordinator = transitionCoordinator else {
            indexPaths.forEach { collectionView.deselectItem(at: $0, animated: animated) }
            return
        }
        coordinator.animate(alongsideTransition: { [weak self] _ in
            indexPaths.forEach { self?.collectionView.deselectItem(at: $0, animated: true) }
        }, completion: { [weak self] context in
            guard context.isCancelled else { return }
            indexPaths.forEach { self?.collectionView.selectItem(at: $0, animated: false, scrollPosition: []) }
        })
    }
}
