// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "xtree",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "xtree", targets: ["CLI"]),
        .library(name: "XTreeKit", targets: ["XTreeKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.1"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(url: "https://github.com/tuist/XcodeProj", from: "9.0.0"),
        .package(url: "https://github.com/swiftyfinch/Fish", from: "0.1.2"),
        .package(url: "https://github.com/jpsim/Yams", from: "5.1.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.19")
    ],
    targets: [
        .executableTarget(name: "CLI", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "Fish",
            "Rainbow",
            "XTreeKit",
            "ZIPFoundation"
        ]),
        .target(name: "XTreeKit", dependencies: [
            "Fish",
            "XcodeProj",
            "Yams"
        ])
    ]
)
