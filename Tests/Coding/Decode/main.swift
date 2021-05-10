import Test
import Stream
import MessagePack

test.case("Bool") {
    let expected = true
    let encoded = try await MessagePack.encode(.bool(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Bool.self)
    expect(decoded == expected)
}

test.case("Float") {
    let expected = Float(1.618)
    let encoded = try await MessagePack.encode(.float(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Float.self)
    expect(decoded == expected)
}

test.case("Double") {
    let expected = Double(1.618)
    let encoded = try await MessagePack.encode(.double(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Double.self)
    expect(decoded == expected)
}

test.case("String") {
    let expected = "Hello, World!"
    let encoded = try await MessagePack.encode(.string(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(String.self)
    expect(decoded == expected)
}

test.case("Int") {
    let expected = Int.min
    let encoded = try await MessagePack.encode(.int(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Int.self)
    expect(decoded == expected)
}

test.case("UInt") {
    let expected = UInt.max
    let encoded = try await MessagePack.encode(.uint(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(UInt.self)
    expect(decoded == expected)
}

test.case("UIntToInt") {
    let expected: UInt = 1
    let encoded = try await MessagePack.encode(.uint(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Int.self)
    expect(UInt(decoded) == expected)
}

test.case("UIntMaxToInt") {
    let expected = UInt.max
    let encoded = try await MessagePack.encode(.uint(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    await expect(throws: MessagePack.Error.invalidData) {
        try await reader.decode(Int.self)
    }
}

test.case("Binary") {
    let expected: [UInt8] = [0x01, 0x02, 0x03]
    let encoded = try await MessagePack.encode(.binary(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode([UInt8].self)
    expect(decoded == expected)
}

test.case("Array") {
    let expected: [MessagePack] = [.string("Hello"), .string("World")]
    let encoded = try await MessagePack.encode(.array(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode([MessagePack].self)
    expect(decoded == expected)
}

test.case("Map") {
    typealias Map = [MessagePack : MessagePack]
    let expected: Map = [.string("Hello"): .string("World")]
    let encoded = try await MessagePack.encode(.map(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Map.self)
    expect(decoded == expected)
}

test.case("Extended") {
    let expected = MessagePack.Extended(
        type: 1, data: [0x01, 0x02, 0x03])
    let encoded = try await MessagePack.encode(.extended(expected))
    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(MessagePack.Extended.self)
    expect(decoded == expected)
}

test.run()
