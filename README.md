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
