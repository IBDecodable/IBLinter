// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "IBLinter",
    products: [
        .executable(name: "main", targets: ["main"]),
        .library(name: "IBLinter", type: .dynamic, targets: ["IBLinter"]),
        .library(name: "IBLinterKit", targets: ["IBLinterKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBDecodable/IBDecodable.git", .branch("master")),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.22.0"),
        .package(url: "https://github.com/xcodeswift/xcproj.git", from: "6.6.0"),
    ],
    targets: [
        .target(
            name: "main",
            dependencies: ["IBLinter"]
        ),
        .target(
            name: "IBLinter",
            dependencies: ["IBLinterKit"]
        ),
        .target(
            name: "IBLinterKit",
            dependencies: [
                "IBDecodable", "Commandant",
                "SourceKittenFramework", "xcodeproj"
            ]
        ),
        .testTarget(
            name: "IBLinterKitTest",
            dependencies: ["IBLinterKit"],
            path: "Tests/IBLinterKitTest"
        ),
        .testTarget(
            name: "IBLinterTest",
            dependencies: ["IBLinter"]
        ),
    ]
)
