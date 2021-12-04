// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImportTool",
    dependencies: [
        .package(url: "https://github.com/yaslab/CSV.swift.git", .upToNextMinor(from: "2.4.3"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ImportTool",
            dependencies: ["ImportToolCore"]),
        .target(
            name: "ImportToolCore",
            dependencies: [
                .product(name: "CSV", package: "CSV.swift")
            ]),
        .testTarget(
            name: "ImportToolCoreTests",
            dependencies: ["ImportToolCore"]),
    ]
)
