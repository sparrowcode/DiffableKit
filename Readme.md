# SPDiffable

<p aligment="left">
    <img src="https://cdn.ivanvorobei.io/github/spdiffable/v2.0/ready-use-cells.png?version=1" height="250"/>
    <img src="https://cdn.ivanvorobei.io/github/spdiffable/v2.0/sidebar.png?version=1" height="250"/>
    <img src="https://cdn.ivanvorobei.io/github/spdiffable/v2.0/info.png?version=1" height="250"/>
</p>

Apple's diffable API requerid models for each object type. If you want use it in many place, you pass many time to implemenet and get over duplicates codes. This project help you do it elegant with shared models and special cell providers for one-usage models.

## Navigate

- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Manually](#manually)
- [Russian Community](#russian-community)

## Installation

Ready for use on iOS and tvOS 13+.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ivanvorobei/SPDiffable", .upToNextMajor(from: "2.2.0"))
]
```

### CocoaPods:

[CocoaPods](https://cocoapods.org) is a dependency manager. For usage and installation instructions, visit their website. To integrate using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SPDiffable'
```

### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/SPDiffable` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Russian Community

Я веду [телеграм-канал](https://sparrowcode.io/telegram), там публикую новости и туториалы.<br>
С проблемой помогут [в чате](https://sparrowcode.io/telegram/chat).

Видео-туториалы выклыдываю на [YouTube](https://ivanvorobei.io/youtube):

[![Tutorials on YouTube](https://cdn.ivanvorobei.io/github/readme/youtube-preview.jpg)](https://ivanvorobei.io/youtube)
