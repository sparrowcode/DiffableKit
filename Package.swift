// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPDiffable",
    platforms: [
        .iOS(.v12), .macOS(.v10_10),
    ],
    products: [
        .library(
            name: "SPDiffable",
            targets: ["SPDiffable"]),
    ],
    targets: [
        .target(
            name: "SPDiffable",
            dependencies: []),
    ]
)
