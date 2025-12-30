// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ToolsayKit",
    products: [
        .library(
            name: "ToolsayKit",
            targets: ["ToolsayKit"]
        ),
    ],
    targets: [
        .target(
            name: "ToolsayKit"
        ),
        .testTarget(
            name: "ToolsayKitTests",
            dependencies: ["ToolsayKit"]
        ),
    ]
)
