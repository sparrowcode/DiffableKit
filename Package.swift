// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "DiffableKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DiffableKit",
            targets: ["DiffableKit"]
        )
    ],
    targets: [
        .target(name: "DiffableKit")
    ]
)
