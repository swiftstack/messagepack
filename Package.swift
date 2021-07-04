// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MessagePack",
    products: [
        .library(
            name: "MessagePack",
            targets: ["MessagePack"])
    ],
    dependencies: [
        .package(name: "Codable"),
        .package(name: "Stream"),
        .package(name: "Radix"),
        .package(name: "Test")
    ],
    targets: [
        .target(
            name: "MessagePack",
            dependencies: ["Codable", "Stream", .product(name: "Hex", package: "Radix")],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"]),
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"])
            ]),
    ]
)

// MARK: - tests

testTarget("Codable") { test in
    test("KeyedDecodingContainer")
    test("KeyedEncodingContainer")
    test("MessagePackCoders")
    test("UnkeyedDecodingContainer")
    test("UnkeyedEncodingContainer")
}

testTarget("Coding") { test in
    test("Array")
    test("Binary")
    test("Bool")
    test("Decode")
    test("EncodeArray")
    test("Extended")
    test("Float")
    test("Init")
    test("InsufficientData")
    test("Integer")
    test("InvalidHeader")
    test("ManualHeaders")
    test("Map")
    test("Nil")
    test("String")
    test("StringEncoding")
    test("Timestamp")
}

testTarget("MessagePack") { test in
    test("Accessors")
    test("ConvenienceInitializers")
    test("Description")
    test("Equality")
    test("HasValue")
    test("LiteralConvertible")
    test("MessagePackInitializable")
}

func testTarget(_ target: String, task: ((String) -> Void) -> Void) {
    task { test in addTest(target: target, name: test) }
}

func addTest(target: String, name: String) {
    package.targets.append(
        .executableTarget(
            name: "Tests/\(target)/\(name)",
            dependencies: ["MessagePack", "Test"],
            path: "Tests/\(target)/\(name)",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"]),
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"])
            ]))
}

// MARK: - custom package source

#if canImport(ObjectiveC)
import Darwin.C
#else
import Glibc
#endif

extension Package.Dependency {
    enum Source: String {
        case local, remote, github

        static var `default`: Self { .local }

        var baseUrl: String {
            switch self {
            case .local: return "../"
            case .remote: return "https://swiftstack.io/"
            case .github: return "https://github.com/swift-stack/"
            }
        }

        func url(for name: String) -> String {
            return self == .local
                ? baseUrl + name.lowercased()
                : baseUrl + name.lowercased() + ".git"
        }
    }

    static func package(name: String) -> Package.Dependency {
        guard let pointer = getenv("SWIFTSTACK") else {
            return .package(name: name, source: .default)
        }
        guard let source = Source(rawValue: String(cString: pointer)) else {
            fatalError("Invalid source. Use local, remote or github")
        }
        return .package(name: name, source: source)
    }

    static func package(name: String, source: Source) -> Package.Dependency {
        return source == .local
            ? .package(name: name, path: source.url(for: name))
            : .package(name: name, url: source.url(for: name), .branch("dev"))
    }
}
