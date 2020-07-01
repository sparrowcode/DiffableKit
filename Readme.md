# SPDiffable

Apple's diffable API requerid models for each object type. If you want use it in many place, you pass many time to implemenet and get over duplicates codes. This project help you do it elegant with shared models and  special cell providers for one-usage models.

If you like the project, don't forget to `put star ★` and follow me on GitHub:

[![https://github.com/ivanvorobei](https://github.com/ivanvorobei/SPPermissions/blob/master/Assets/Buttons/follow-me-on-github.svg)](https://github.com/ivanvorobei)

## Navigate

- [Requirements](#requirements)
- [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
    - [Carthage](#carthage)
    - [Manually](#manually)
- [Usage](#usage)
    - [How it work](#usage)
    - [Apply content](#apply-content)
    - [Ready Use Models](#ready-use-models)
    - [Mediator](#mediator)
- [Сooperation](#сooperation)
- [Russian Community](#russian-community)
- [License](#license)

## Requirements

Swift `+5.0`. Ready for use on iOS 13+

## Installation

### CocoaPods:

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate `SPDiffable` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SPDiffable'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate `SPDiffable` into your Xcode project using Xcode 11, specify it in `File > Swift Packages > Add`:

```ogdl
https://github.com/ivanvorobei/SPDiffable
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate `SPDiffable` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "ivanvorobei/SPDiffable"
```

### Manually

If you prefer not to use any of dependency managers, you can integrate `SPDiffable` into your project manually. Put `Source/SPDiffable` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Usage

Before read it, highly recomded check `Example` target in project. It examle show all features, like use stepper and switch, like process actions, create custom models and many other.

For work with diffable need create model (inside project you found some ready-use models) and do cell provider, which convert model with data to `UITableViewCell` or `UICollectionViewCell`.

New model shoud extend from basic class `SPDiffableItem`:

```swift
class TableRowModel: SPDiffableItem {}
```

After it add properties, which you want use:

```swift
class TableRowMode: SPDiffableItem {

    public var text: String
    public var detail: String? = nil
    public var icon: UIImage? = nil
    public var selectionStyle: UITableViewCell.SelectionStyle
    public var accessoryType: UITableViewCell.AccessoryType
}
```

Last step, create table controller class and extend of `SPDiffableTableController`. Create custom cell provider, it help convert it data to table cell:

```swift

override func viewDidLoad() {
    super.viewDidLoad()
    
    // Register cell for usage it in table view
    tableView.register(NativeTableViewCell.self, forCellReuseIdentifier: NativeTableViewCell.identifier)
    
    // Cell provider for `TableRowMode`
    let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, model) -> UITableViewCell? in
        switch model {
        case let model as TableRowMode:
            let cell = tableView.dequeueReusableCell(withIdentifier: NativeTableViewCell.identifier, for: indexPath) as! NativeTableViewCell
            cell.textLabel?.text = model.text
            cell.detailTextLabel?.text = model.detail
            cell.accessoryType = model.accessoryType
            cell.selectionStyle = model.selectionStyle
            return cell
        default:
            return nil
        }
    }
    
    // Pass cell provider and content. 
    // About content you can read next.
    setCellProviders([cellProvider], sections: content)
}
```

For example usage you can find in project in taget `Example`.

### Apply Content

Now table support models and custom cell provider. We can apply diffable content with animation (or not).
Create section class:

```swift
let section = SPDiffableSection(
    identifier: "example section",
    header: SPDiffableTableTextHeader(text: "Header"),
    footer: SPDiffableTableTextFooter(text: "Footer"),
    items: [
        SPDiffableTableRow(text: "Basic Table Cell", accessoryType: .disclosureIndicator, action: { [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            print("Tapped")
        })
    ]
)

let content = [section]
```

You can add more cells or sections. Last step - apply:

```swift
diffableDataSource?.apply(sections: content, animating: true)
```

That all. You can each time create new order or count cells and it automatically show with diffable animation. Project has some ready-use models, you can read about it next.

### Ready Use Models

It models which you can use now, it shoud close your task without code. Of couse you can create your models.
Now in project you can find this ready-use models:

- `SPDiffableItem` it basic class. All item models shoud be extend from it model.
- `SPDiffableSection` basic section class. Included footer and header, also items (cells).
- `SPDiffableHeader` basic header class. All headers shoud be extend from it class.
- `SPDiffableFooter` basic footer class. All footers shoud be extend from it class.

#### For Table:

- `SPDiffableTableRow` it native table view cell. Support all basic styles and action for tap event.
- `SPDiffableTableRowStepper` table view cell with stepper. Has maximum value and minimum, also incuded action with passed value.
- `SPDiffableTableRowSwitch` table cell with switch, included default state and action for change event.
- `SPDiffableTableRowButton` table cell with style as button. Supprt table styles and action for tap.
- `SPDiffableTableTextHeader` table header with text. You can see it in native table.
- `SPDiffableTableTextFooter` table footer text.

#### For Collection:

Now in progress development.

### Mediator

Some methods in diffable data source can't ovveride without custom data source. It solved with mediator delegate. It simple. Next example for table. Set delegate `SPTableDiffableMediator`, all method optional:

```swift
class DiffableTableController: SPDiffableTableController, SPTableDiffableMediator {

    override func viewDidLoad() {
        super.viewDidLoad()
        setCellProviders([cellProvider], sections: content)
        diffableDataSource?.mediator = self
    }
}
```

Now you can implemented requerid methods, for example title of header:

```swift
func diffableTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Overridden in of diffable mediator"
}
```

In protocol you can find more methods, like `canEdit` and other.

## Сooperation

This project is free, but developing it takes time. Contributing to this project is a huge help. Here is list of tasks that need to be done, you can help with any:

- Update readme text, my English not great :(
- Add docs to swift source files

## Russian Community

Присоединяйтесь в телеграм канал [Код Воробья](https://ivanvorobei.by/xcode-tutorials/telegram), там найдете короткие ролики о iOS разработке и дизайне.
Большие ролики выклыдываю на [YouTube](https://ivanvorobei.by/xcode-tutorials/youtube).

## License

`SPDiffable` is released under the MIT license. Check `LICENSE.md` for details.
