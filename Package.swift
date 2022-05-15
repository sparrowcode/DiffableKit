// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DiffableKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DiffableKit",
            targets: ["DiffableKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DiffableKit",
            swiftSettings: [
                .define("DIFFABLEKIT_SPM")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
