// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ToolsayKit",
    platforms: [.iOS(.v17), .macOS(.v14)],
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
