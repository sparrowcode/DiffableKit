// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SPDiffable",
    platforms: [
        .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "SPDiffable",
            targets: ["SPDiffable"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SPDiffable",
            swiftSettings: [
                .define("SPDIFFABLE_SPM")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
