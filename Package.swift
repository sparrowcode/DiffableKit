// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SPDiffable",
    platforms: [
       .iOS(.v13)
    ],
    products: [
        .library(name: "SPDiffable", targets: ["SPDiffable"])
    ],
    targets: [
        .target(name: "SPDiffable")
    ]
)
