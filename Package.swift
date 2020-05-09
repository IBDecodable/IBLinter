// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "IBLinter",
    platforms: [.macOS(.v10_11)],
    products: [
        .executable(
            name: "iblinter", targets: ["IBLinter"]
        ),
        .library(
            name: "IBLinterFrontend",
            type: .dynamic, targets: ["IBLinterFrontend"]
        ),
        .library(
            name: "IBLinterKit", targets: ["IBLinterKit"]
        ),
        .executable(
            name: "iblinter-tools", targets: ["Tools"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/IBDecodable/IBDecodable.git", from: "0.4.0"),
        .package(url: "https://github.com/Carthage/Commandant.git", .upToNextMinor(from: "0.17.0")),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.29.0"),
        .package(url: "https://github.com/tuist/XcodeProj.git", from: "7.10.0"),
    ],
    targets: [
        .target(
            name: "IBLinter",
            dependencies: ["IBLinterFrontend"]
        ),
        .target(
            name: "IBLinterFrontend",
            dependencies: ["IBLinterKit"]
        ),
        .target(
            name: "IBLinterKit",
            dependencies: [
                "IBDecodable", "Commandant",
                "SourceKittenFramework", "XcodeProj"
            ]
        ),
        .target(
            name: "Tools",
            dependencies: ["IBLinterKit", "Commandant"]
        ),
        .testTarget(
            name: "IBLinterKitTest",
            dependencies: ["IBLinterKit"],
            exclude: [
                "Resources"
            ]
        ),
    ]
)
