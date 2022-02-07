// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bee",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "bee", targets: ["Bee"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.2.0"),
        .package(name: "XcodeProj", url: "https://github.com/tuist/xcodeproj", from: "8.5.0")
    ],
    targets: [
        .target(name: "Bee", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "Rainbow",
            "Files",
            "XcodeProj"
        ])
    ]
)
