// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CachedNetworkImage",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16),
        .visionOS(.v1),
        .watchOS(.v8),
        .tvOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CachedNetworkImage",
            targets: ["CachedNetworkImage"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CachedNetworkImage"),
        .testTarget(
            name: "CachedNetworkImageTests",
            dependencies: ["CachedNetworkImage"]
        ),
    ]
)
