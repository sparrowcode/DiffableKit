# DiffableKit

Wrapper around `UITableViewDiffableDataSource` and `UICollectionViewDiffableDataSource`. Removes boilerplate — describe sections and rows as models, get animated updates out of the box.

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
