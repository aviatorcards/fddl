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
        .package(url: "https://github.com/apple/swift-markdown.git", from: "0.5.0")
    ],
    targets: [
        .executableTarget(
            name: "fddl",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Yams", package: "Yams"),
                .product(name: "Markdown", package: "swift-markdown")
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
