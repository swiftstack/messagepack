import Test
@testable import MessagePack

test.case("Encodable") {
    struct Model: Encodable {
        let int: Int
        let string: String
        let array: [Int]
    }
    let expected: MessagePack = .map([
        .string("int"): .int(42),
        .string("string"): .string("hello"),
        .string("array"): .array([.int(1), .int(2)])
    ])

    let model = Model(int: 42, string: "hello", array: [1,2])
    let encoder = Encoder()
    try model.encode(to: encoder)
    expect(encoder.value == expected)
}

test.case("Decodable") {
    struct Model: Decodable {
        let int: Int
        let string: String
        let array: [Int]
    }
    let encoded: MessagePack = .map([
        .string("int"): .int(42),
        .string("string"): .string("hello"),
        .string("array"): .array([.int(1), .int(2)])
    ])

    let decoder = Decoder(encoded)
    let decoded = try Model(from: decoder)

    expect(decoded.int == 42)
    expect(decoded.string == "hello")
    expect(decoded.array == [1,2])
}

test.run()
