// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "MessagePack",
    products: [
        .library(name: "MessagePack", targets: ["MessagePack"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-stack/test.git",
            from: "0.4.0"
        )
    ],
    targets: [
        .target(name: "MessagePack"),
        .testTarget(
            name: "MessagePackTests",
            dependencies: ["MessagePack", "Test"]
        )
    ]
)
