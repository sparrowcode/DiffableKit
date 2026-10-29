# DiffableKit

Declarative wrapper around `UITableViewDiffableDataSource` and `UICollectionViewDiffableDataSource`. Describe sections and items, call `set()` — diffing, animations, and cell updates are handled automatically.

## Installation

In Xcode: File → Add Package Dependencies → paste URL:

```
https://github.com/sparrowcode/DiffableKit
```

## Usage

```swift
class SettingsController: DiffableTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDiffable(
            sections: [
                DiffableSection(
                    id: "general",
                    header: DiffableTextHeaderFooter(text: "General"),
                    items: [
                        DiffableTableRow(text: "Theme", detail: "System", accessoryType: .disclosureIndicator)
                    ]
                )
            ],
            cellProviders: DiffableTableDataSource.CellProvider.default
        )
    }
}
```

### List

```swift
// Same models in a UICollectionView list with the system Settings metrics
class SettingsController: DiffableListController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDiffable(
            sections: [
                DiffableSection(
                    id: "general",
                    header: DiffableTextHeaderFooter(text: "General"),
                    items: [
                        DiffableTableRow(text: "Theme", detail: "System", accessoryType: .disclosureIndicator),
                        DiffableTableRowSwitch(text: "Sounds", isOn: true, action: { isOn in })
                    ]
                )
            ],
            cellProviders: DiffableListDataSource.CellProvider.default
        )
        // Header above the list instead of tableHeaderView
        headerView = UIView()
    }
}

// Context menu and swipes come through the delegate
diffableDataSource?.diffableDelegate = self
```
