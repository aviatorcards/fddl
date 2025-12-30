// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "fddl",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "fddl", targets: ["fddl"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "6.0.0"),
        .package(url: "https://github.com/apple/swift-markdown.git", from: "0.5.0"),
        .package(url: "https://github.com/apple/swift-nio.git", exact: "2.62.0"),
        .package(url: "https://github.com/apple/swift-nio-extras.git", exact: "1.20.0"),
        .package(url: "https://github.com/JohnSundell/Splash.git", from: "0.16.0")
    ],
    targets: [
        .executableTarget(
            name: "fddl",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Yams", package: "Yams"),
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOWebSocket", package: "swift-nio"),
                .product(name: "NIOExtras", package: "swift-nio-extras"),
                .product(name: "Splash", package: "Splash")
            ],
            path: "Sources/fddl"
        ),
        .testTarget(
            name: "fddlTests",
            dependencies: ["fddl"],
            path: "Tests/fddlTests"
        )
    ]
)
