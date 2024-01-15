import Test
import MessagePack

test("EncodeFixArray") {
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]
    let encoded = try await MessagePack.encode(
        .array([.int(1), .int(2), .int(3)]))
    expect(encoded == expected)
}

test("DecodeFixarray") {
    let expected = MessagePack.array([.uint(1), .uint(2), .uint(3)])
    let decoded = try await MessagePack.decode(bytes: [0x93, 0x01, 0x02, 0x03])
    expect(decoded == expected)
}

test("EncodeArray16") {
    let expected =
        [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max))
    let encoded = try await MessagePack.encode(
        .array([MessagePack](repeating: nil, count: Int(UInt16.max))))
    expect(encoded == expected)
}

test("DecodeArray16") {
    let expected = MessagePack.array(
        [MessagePack](repeating: nil, count: Int(UInt16.max)))
    let decoded = try await MessagePack.decode(
        bytes: [0xdc, 0xff, 0xff]
            + [UInt8](repeating: 0xc0, count: Int(UInt16.max)))
    expect(decoded == expected)
}

test("EncodeArray32") {
    let expected =
        [0xdd, 0x00, 0x01, 0x00, 0x00] +
            [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1)
    let encoded = try await MessagePack.encode(
        .array([MessagePack](repeating: nil, count: Int(UInt16.max)+1)))
    expect(encoded == expected)
}

test("DecodeArray32") {
    let expected = MessagePack.array(
        [MessagePack](repeating: nil, count: Int(UInt16.max)+1))
    let decoded = try await MessagePack.decode(
        bytes: [0xdd, 0x00, 0x01, 0x00, 0x00] +
            [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1))
    expect(decoded == expected)
}

test("EmptyArray") {
    let arrayArray: [[UInt8]] = [
        [0x90],
        [0xdc, 0x00, 0x00],
        [0xdd, 0x00, 0x00, 0x00, 0x00]
    ]
    for bytes in arrayArray {
        let object = try await MessagePack.decode(bytes: bytes)
        expect(object.arrayValue == [])
    }
}

test("FixArraySize") {
    let items = [MessagePack](repeating: .int(1), count: 15)
    let bytes = try await MessagePack.encode(.array(items))
    expect(bytes.count == 16)
}

await run()
