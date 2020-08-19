# SPDiffable

Apple's diffable API requerid models for each object type. If you want use it in many place, you pass many time to implemenet and get over duplicates codes. This project help you do it elegant with shared models and special cell providers for one-usage models.

If you like the project, don't forget to `put star ★` and follow me on GitHub:

[![https://github.com/ivanvorobei](https://github.com/ivanvorobei/Assets/blob/master/Buttons/follow-me-on-github.svg)](https://github.com/ivanvorobei)

If you want help project, check [Сooperation](#сooperation) section.

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
    - [Mediator](#mediator)
    - [Sidebar](#sidebar)
- [Ready Use Models](#ready-use-models)
- [Сooperation](#сooperation)
- [Other Projects](#other-projects)
- [Russian Community](#russian-community)

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

For work with diffable need create model (inside project you found some ready-use models) and do cell provider, which convert model with data to `UITableViewCell` or `UICollectionViewCell`. Next example for table, but all methods and class names available for collections.

New model shoud extend from basic class `SPDiffableItem`:

```swift
class TableRowModel: SPDiffableItem {}
```

After it add properties, which you want use. For example:

```swift
class TableRowModel: SPDiffableItem {

    public var text: String
    public var detail: String? = nil
    public var icon: UIImage? = nil
    public var selectionStyle: UITableViewCell.SelectionStyle
    public var accessoryType: UITableViewCell.AccessoryType
}
```

Last step, create table controller class and extend of `SPDiffableTableController`. Create custom cell provider, it doing convert it data to table cell:

```swift

override func viewDidLoad() {
    super.viewDidLoad()
    
    // Register cell for usage it in table view
    tableView.register(SPDiffableTableViewCell.self, forCellReuseIdentifier: SPDiffableTableViewCell.reuseIdentifier)
    
    // Cell provider for `TableRowModel`
    let cellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, model) -> UITableViewCell? in
        switch model {
        case let model as TableRowModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: YourTableViewCell.identifier, for: indexPath) as! YourTableViewCell
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
You can use default cell provider if using project's models. For get it call `SPDiffableTableController.defaultCellProvider`.
All actions similar to collections. For example usage you can find in project in taget `Example`.

### Apply Content

Now table support models and custom cell provider. We can apply diffable content with animation (or not).
Create section class:

```swift
let section = SPDiffableSection(
    identifier: "example section",
    header: SPDiffableTextHeaderFooter(text: "Header"),
    footer: SPDiffableTextHeaderFooter(text: "Footer"),
    items: [
        TableRowModel(text: "Basic Table Cell", accessoryType: .disclosureIndicator, action: { [weak self] indexPath in
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

### Sidebar

Create new controller and extend from `SPDiffableSideBarController`. Remember, it available only from iOS 14. Now it abailable for `ios14` branch.

```swift
class SidebarController: SPDiffableSideBarController {}
```

In class available ready-use cell providers for menu item and header section. For get it shoud call:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    setCellProviders([CellProvider.item, CellProvider.button, CellProvider.header], sections: content)
    // or you can set all default providers by call `CellProvider.all`
}
```

Content it array of `SPDiffableSection`. For menu model need use model `SPDiffableSideBarItem` or `SPDiffableSideBarButton`. For header and footer will create `SPDiffableSideBarHeader` model.

```swift
SPDiffableSection(
    identifier: Section.library.rawValue,
    header: SPDiffableSideBarHeader(text: "Library", accessories: [.outlineDisclosure()]),
    items: [
        SPDiffableSideBarItem(title: "Recently Added", image: UIImage(systemName: "clock"), action: { _ in }),
        SPDiffableSideBarItem(title: "Artists", image: UIImage(systemName: "music.mic"), action: { _ in }),
        SPDiffableSideBarItem(title: "Albums", image: UIImage(systemName: "rectangle.stack"), action: { _ in }),
        SPDiffableSideBarItem(title: "Songs", image: UIImage(systemName: "music.note"), action: { _ in }),
        SPDiffableSideBarButton(title: "Add New", image: UIImage(systemName: "plus.square.fill"), action: { _ in })
    ]
)
```

## Ready Use Models

It models which you can use now, it shoud close your task without code. Of couse you can create your models.
Now in project you can find this ready-use models:

- `SPDiffableItem` it basic class. All item models shoud be extend from it model. Header and footer also.
- `SPDiffableSection` section class. Included footer and header properties, also items (cells).
- `SPDiffableTextHeaderFooter` header or footer class with text.

#### For Table:

- `SPDiffableTableRow` it native item for table cell. Support all basic styles and action for tap event.
- `SPDiffableTableRowSubtitle` it native item for table cell with subtitle. Support all as before.
- `SPDiffableTableRowStepper` item for table cell with stepper. Has maximum value and minimum, also incuded action with passed value.
- `SPDiffableTableRowSwitch` item for table with switch, included default state and action for change event.
- `SPDiffableTableRowButton` item for table in style as button. Support table styles and action for tap.

- `SPDiffableTableViewCell` basic table cell with detail text right side.
- `SPDiffableSubtitleTableViewCell` basic table cell with two lines of texts.

#### For Collection:

Now in progress development.

- `SPDiffableSideBarItem` menu item in side bar. Support accessories and actions.
- `SPDiffableSideBarButton` button item in side bar. Color of title similar to tint.
- `SPDiffableSideBarHeader` header model for side bar item.

## Сooperation

This project is free, but developing it takes time. Contributing to this project is a huge help. Here is list of tasks that need to be done, you can help with any:

- Update readme text, my English not great :(
- Update docs to swift source files

## Other Projects

#### [SPPermissions](https://github.com/ivanvorobei/SPPermissions)
Allow request permissions with native dialog UI and interactive animations. Also you can request permissions without dialog. Check state any permission. You can start using this project with just two lines of code and easy customisation.

#### [SPAlert](https://github.com/ivanvorobei/SPAlert)
It is popup from Apple Music & Feedback in AppStore. Contains Done & Heart presets. Done present with draw path animation. I clone Apple's alerts as much as possible.
You can find this alerts in AppStore after feedback, after added song to library in Apple Music. I am also add alert without icon, as simple message.

## Russian Community

Присоединяйтесь в телеграм канал [Код Воробья](https://sparrowcode.ivanvorobei.by/telegram), там найдете заметки о iOS разработке и дизайне.
Большие туториалы выклыдываю на [YouTube](https://sparrowcode.ivanvorobei.by/youtube).

[![Tutorials on YouTube](https://github.com/ivanvorobei/Assets/blob/master/Russian%20Community/youtube-preview.jpg)](https://sparrowcode.ivanvorobei.by/youtube)
