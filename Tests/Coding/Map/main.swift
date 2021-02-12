import Test
import MessagePack

func makeMap(repeating: MessagePack, count: Int) -> [MessagePack: MessagePack] {
    var map: [MessagePack: MessagePack] = [:]
    for i in 0..<count {
        map[.uint(UInt(i))] = repeating
    }
    return map
}

func makeEncodedMapData(
    repeating: MessagePack,
    count: Int
) async throws -> [UInt8] {
    var bytes: [UInt8] = []
    for i in 0..<count {
        bytes.append(contentsOf: try await MessagePack.encode(.uint(UInt(i))))
        bytes.append(contentsOf: try await MessagePack.encode(repeating))
    }
    return bytes
}

test.case("EncodeFixMap") {
    let expected: [UInt8] = [
        0x81, 0xa5, 0x68, 0x65, 0x6c, 0x6c, 0x6f, 0xa5,
        0x77, 0x6f, 0x72, 0x6c, 0x64]
    let encoded = try await MessagePack.encode(
        .map([.string("hello"): .string("world")]))
    expect(encoded == expected)
}

test.case("DecodeFixMap") {
    let expected = MessagePack.map([.string("hello"): .string("world")])
    let decoded = try await MessagePack.decode(bytes: [
        0x81, 0xa5, 0x68, 0x65, 0x6c, 0x6c, 0x6f, 0xa5,
        0x77, 0x6f, 0x72, 0x6c, 0x64])
    expect(decoded == expected)
}

test.case("EncodeMap16") {
    let header: [UInt8] = [0xde, 0x01, 0x00]
    let expected = header + (try await makeEncodedMapData(
        repeating: .nil, count: Int(UInt8.max) + 1))
    let encoded = try await MessagePack.encode(
        .map(makeMap(repeating: nil, count: Int(UInt8.max) + 1)))
    expect(encoded.prefix(3) == expected.prefix(3))
    expect(encoded.sorted() == expected.sorted())
}

test.case("DecodeMap16") {
    let expected = MessagePack.map(
        makeMap(repeating: nil, count: Int(UInt8.max) + 1))
    let decoded = try await MessagePack.decode(
        bytes: [0xde, 0x01, 0x00] + makeEncodedMapData(
            repeating: .nil, count: Int(UInt8.max) + 1))
    expect(decoded == expected)
}

test.case("EncodeMap32") {
    let expected: [UInt8] = [0xdf, 0x00, 0x01, 0x00, 0x00] +
        (try await makeEncodedMapData(
            repeating: .nil,
            count: Int(UInt16.max) + 1))
    let encoded = try await MessagePack.encode(
        .map(makeMap(repeating: nil, count: Int(UInt16.max) + 1)))
    expect(encoded.prefix(3) == expected.prefix(3))
    expect(encoded.sorted() == expected.sorted())
}

test.case("DecodeMap32") {
    let expected = MessagePack.map(
        makeMap(repeating: nil, count: Int(UInt16.max) + 1))
    let decoded = try await MessagePack.decode(
        bytes: [0xdf, 0x00, 0x01, 0x00, 0x00] +
            makeEncodedMapData(repeating: .nil, count: Int(UInt16.max) + 1))
    expect(decoded == expected)
}

test.case("EmptyMap") {
    let mapArray: [[UInt8]] = [
        [0x80],
        [0xde, 0x00, 0x00],
        [0xdf, 0x00, 0x00, 0x00, 0x00]
    ]
    for bytes in mapArray {
        let object = try await MessagePack.decode(bytes: bytes)
        expect(object.dictionaryValue == [:])
    }
}

test.case("FixMapSize") {
    var items = [MessagePack : MessagePack]()
    for i in 1...15 {
        items[.int(i)] = .int(i)
    }
    let bytes = try await MessagePack.encode(.map(items))
    expect(bytes.count == 31)
}

test.run()
