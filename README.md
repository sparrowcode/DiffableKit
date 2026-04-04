# DiffableKit

Wrapper around `UITableViewDiffableDataSource` and `UICollectionViewDiffableDataSource`. Just call `set()` with your content whenever something changes — diffing, animations, and cell updates are handled automatically under the hood.

Built-in row types for settings screens. Cell provider, header/footer provider, delegate with actions — all wired up declaratively.

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
