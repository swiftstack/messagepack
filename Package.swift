// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "MessagePack",
    products: [
        .library(name: "MessagePack", targets: ["MessagePack"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-stack/codable.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/stream.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/radix.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/test.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "MessagePack",
            dependencies: ["Codable", "Stream", "Hex"]),
        .testTarget(
            name: "MessagePackTests",
            dependencies: ["MessagePack", "Test"])
    ]
)
