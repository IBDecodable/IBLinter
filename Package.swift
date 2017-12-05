// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IBLinter",
    products: [
        .executable(name: "iblinter", targets: ["iblinter"]),
        .library(name: "IBLinterKit", targets: ["IBLinterKit"]),
        .library(name: "IBLinterCore", targets: ["IBLinterCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.0.0"),
        .package(url: "https://github.com/Carthage/Commandant.git", .branch("master")),
        .package(url: "https://github.com/jpsim/Yams.git", from: "0.4.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "iblinter",
            dependencies: ["IBLinterKit"]),
        .target(
            name: "IBLinterCore",
            dependencies: ["SWXMLHash"]),
        .target(
            name: "IBLinterKit",
            dependencies: ["IBLinterCore", "Commandant", "Yams"]),
        .testTarget(name: "IBLinterKitTest",
            dependencies: ["IBLinterKit"])
    ]
)
