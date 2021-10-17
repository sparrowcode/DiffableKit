# SPDiffable

<img align="left" src="https://cdn.ivanvorobei.by/github/spdiffable/example-app-preview-2.png" width="450"/>

Apple's diffable API requerid models for each object type. If you want use it in many place, you pass many time to implemenet and get over duplicates codes. This project help you do it elegant with shared models and special cell providers for one-usage models.

I made example app with features and video preview:

[![https://opensource.ivanvorobei.by/spdiffable/preview](https://github.com/ivanvorobei/Readme/blob/main/Buttons/video-preview.svg)](https://opensource.ivanvorobei.by/spdiffable/preview)

You can make sidebar, apply changes and make settings screen without making any cells or models. Check readme docs to learn how it work. 

If you like the project, don't forget to `put star ★`<br>Check out my other libraries:

<p float="left">
    <a href="https://opensource.ivanvorobei.by">
        <img src="https://github.com/ivanvorobei/Readme/blob/main/Buttons/more-libraries.svg">
    </a>
</p>

## Navigate

- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Manually](#manually)
- [Usage](#usage)
    - [How it work](#usage)
    - [Mediator](#mediator)
    - [Diffable Delegate](#diffable-delegate)
    - [Sidebar](#sidebar)
- [Ready Use](#ready-use)
    - [Example](#ready-use)
    - [List classes](#ready-use-classes)
    - [Wrapper](#wrapper)
- [Сontribution](#сontribution)
- [Other Projects](#other-projects)
- [Russian Community](#russian-community)

## Installation

Ready for use on iOS 13+. Works with Swift 5+. Required Xcode 12.0 and higher.

<img align="right" src="https://cdn.ivanvorobei.by/github/spdiffable/spm-install-preview.png" width="550"/>

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ivanvorobei/SPDiffable.git", .upToNextMajor(from: "1.6.0"))
]
```

### CocoaPods:

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SPDiffable'
```

### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/SPDiffable` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Usage

Before read it, highly recomded check `Example` target in project. It examle show all features, like use stepper and switch, like process actions, create custom models and many other. Also you can skip full undestand logic and read [Ready-use section](https://github.com/ivanvorobei/SPDiffable#ready-use) with minimum of code for start.

For work with diffable need create model (inside project you found some ready-use models) and do cell provider, which convert data-model to `UITableViewCell` or `UICollectionViewCell`. Next example for table, but all methods and class names available for collections.

New model shoud extend from basic class `SPDiffableItem`:

```swift
class LocationRowModel: SPDiffableItem {

    // Add properties, which you need
    public var city: String
    public var adress: String?
}
```

Last step, create table controller class and extend of `SPDiffableTableController`. Create custom cell provider, it doing convert it data to table cell:

```swift
class DiffableTableController: SPDiffableTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell for usage it in table view
        tableView.register(LocationTableCell.self, forCellReuseIdentifier: "LocationTableCell")
        
        // Cell provider for `LocationRowModel`
        let locationCellProvider: SPDiffableTableCellProvider = { (tableView, indexPath, model) -> UITableViewCell? in
            switch model {
            case let model as TableRowModel:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell", for: indexPath) as! LocationTableCell
                cell.textLabel?.text = model.city
                cell.detailTextLabel?.text = model.adress
                return cell
            default:
                return nil
            }
        }
        
        // Pass cell provider and content. 
        // About content you can read in next section.
        setCellProviders([locationCellProvider], sections: content)
    }
}
```

Now ready model and convert it to views. Time to add content. Read next section.

#### Apply Content

Now table support models and custom cell provider. You can apply diffable content with animation (or not).
Create content:

```swift

var content: [SPDiffableSection] {
    let section = SPDiffableSection(
        identifier: "example section",
        header: SPDiffableTextHeaderFooter(text: "Header"),
        footer: SPDiffableTextHeaderFooter(text: "Footer"),
        items: [
            LocationRowModel(city: "Minsk", adress: "Frunze Pr., bld. 47, appt. 7"),
            LocationRowModel(city: "Shanghai", adress: "Ting Wei Gong Lu 9299long 168hao"),
            LocationRowModel(city: "London", adress: "94  Whitby Road")
        ]
    )

    let content = [section]
    return content
}
```

You can add more items or sections. Last step - apply:

```swift
diffableDataSource?.apply(content, animating: true)
```

Call this when you need update content. When you call `setCellProviders`, it set content by default without animation.
That all. You can each time create new order or count cells and it automatically show with diffable animation.

#### Reload Content

If you need something like old function `.reloadData()` in collection and table, look at this method:

```swift
diffableDataSource?.reload(content)
```

Changes apply without animation and like deep reload.

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

### Diffable Delegate

For handle some useful extensions, you can use delegates `SPDiffableTableDelegate`, `SPDiffableCollectionDelegate`. For example, when you need get which model did select, use this:

```swift
class DiffableTableController: SPDiffableTableController, SPDiffableTableDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hidded code for cell providers and content
        
        setCellProviders([cellProvider], sections: content)
        diffableDelegate = self
    }
    
    func diffableTableView(_ tableView: UITableView, didSelectItem item: SPDiffableItem) {
        // Here you get model, which did select.
    }
} 
```

### Sidebar

Create new controller and extend from `SPDiffableSideBarController`. Remember, it available only from iOS 14. 

```swift
class SidebarController: SPDiffableSideBarController {}
```

In class available ready-use cell providers for menu item and header section. For get it shoud call:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    setCellProviders(SPDiffableCollectionCellProviders.sideBar, sections: content)
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

## Ready Use

You can save time and count lines of code using ready-use classes. In project available models and views. For example you need simple table with native cells. You need create content with `SPDiffableTableRow`:

```swift
let section = SPDiffableSection(
    identifier: "example section",
    header: SPDiffableTextHeaderFooter(text: "Header"),
    footer: SPDiffableTextHeaderFooter(text: "Footer"),
    items: [
        SPDiffableTableRow(text: "First Cell", accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }),
        SPDiffableTableRow(text: "Second Cell", accessoryType: .disclosureIndicator, selectionStyle: .default, action: { [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }),
    ]
)
```

You init cell model and pass action, choose selection style and other. As you see, model describe native table cell. Next, you need set cell provider, but it also already available, for get it call `SPDiffableTableController.defaultCellProvider`.

```swift
setCellProviders(SPDiffableTableCellProviders.default, sections: [section])
```

Now project's models automatically converting to cell. No need any additional work. That all code. 
If you use custom table view or table controller, don't forget register cells classes.  For `SPDiffableTableController` all cells already registered.

## Ready-use classes

It list models which you can use now, it shoud close your task without code. Of couse you can create your models.
Now in project you can find this ready-use models:

- `SPDiffableItem` it basic class. All item models shoud be extend from it model. Header and footer also.
- `SPDiffableSection` section class. Included footer and header properties, also items (cells).
- `SPDiffableTextHeaderFooter` header or footer class with text.

#### For Table:

Here provided models:

- `SPDiffableTableRow` it native item for table cell. Support all basic styles and action for tap event.
- `SPDiffableTableRowSubtitle` it native item for table cell with subtitle. Support all as before.
- `SPDiffableTableRowButton` item for table in style as button. Support table styles and action for tap.
- `SPDiffableTableRowStepper` item for table cell with stepper. Has maximum value and minimum, also incuded action with passed value.
- `SPDiffableTableRowSwitch` item for table with switch, included default state and action for change event.

Here provided cells:

- `SPDiffableTableViewCell` basic table cell with detail text right side.
- `SPDiffableSubtitleTableViewCell` basic table cell with two lines of texts.
- `SPDiffableStepper` cell with stepper control. Using with `SPDiffableTableRowStepper` model.
- `SPDiffableSwitch` cell with switch. Using with `SPDiffableTableRowSwitch` model.
- `SPDiffableSlider` cell with slider.

#### For Collection:

Provided only models, becouse for most items using list registration and no need specific cell class.

- `SPDiffableCollectionActionableItem` actionable item for collection view.
- `SPDiffableSideBarItem` menu item in side bar. Support accessories and actions.
- `SPDiffableSideBarButton` button item in side bar. Color of title similar to tint.
- `SPDiffableSideBarHeader` header model for side bar item.

## Wrapper

In project you can find class `SPDiffableWrapperItem`. Using it, when you don't want create custom item model for you diffable struct. You can pass any your model and uwrap it later in cell provider.

```swift
let item = SPDiffableWrapperItem(identifier: "uniq-identifier", model: LocationRowModel(city: "Minsk"))
```

## Сontribution

My English is very bad. You can see this once you read the documentation. I would really like to have clean and nice documentation. If you see gramatical errors and can help fix the Readme, please contact me hello@ivanvorobei.by or make a Pull Request. Thank you in advance!

## Other Projects

I love being helpful. Here I have provided a list of libraries that I keep up to date. For see `video previews` of libraries without install open [opensource.ivanvorobei.by](https://opensource.ivanvorobei.by) website.<br>
I have libraries with native interface and managing permissions. Also available pack of useful extensions for boost your development process.

<p float="left">
    <a href="https://opensource.ivanvorobei.by">
        <img src="https://github.com/ivanvorobei/Readme/blob/main/Buttons/more-libraries.svg">
    </a>
        <a href="https://xcodeshop.ivanvorobei.by">
        <img src="https://github.com/ivanvorobei/Readme/blob/main/Buttons/xcode-shop.svg">
    </a>
</p>

## Russian Community

Подписывайся в телеграмм-канал, если хочешь получать уведомления о новых туториалах.<br>
Со сложными и непонятными задачами помогут в чате.

<p float="left">
    <a href="https://tutorials.ivanvorobei.by/telegram/channel">
        <img src="https://github.com/ivanvorobei/Readme/blob/main/Buttons/open-telegram-channel.svg">
    </a>
    <a href="https://tutorials.ivanvorobei.by/telegram/chat">
        <img src="https://github.com/ivanvorobei/Readme/blob/main/Buttons/russian-community-chat.svg">
    </a>
</p>

Видео-туториалы выклыдываю на [YouTube](https://tutorials.ivanvorobei.by/youtube):

[![Tutorials on YouTube](https://cdn.ivanvorobei.by/github/readme/youtube-preview.jpg)](https://tutorials.ivanvorobei.by/youtube)
