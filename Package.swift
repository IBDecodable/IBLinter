// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IBLinter",
    products: [
        .executable(name: "iblinter", targets: ["iblinter"]),
        .library(name: "IBLinterKit", type: .dynamic, targets: ["IBLinterKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/IBDecodable/IBDecodable.git", .branch("master")),
        .package(url: "https://github.com/Carthage/Commandant.git", .branch("master")),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.21.1"),
        .package(url: "https://github.com/xcodeswift/xcproj.git", from: "4.3.0"),
        .package(url: "https://github.com/JohnSundell/Marathon.git", from: "3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "iblinter",
            dependencies: ["IBLinterKit"]),
        .target(
            name: "IBLinterKit",
            dependencies: ["IBDecodable", "Commandant", "SourceKittenFramework", "xcproj", "MarathonCore"]),
        .testTarget(name: "IBLinterKitTest",
            dependencies: ["IBLinterKit"])
    ]
)
