import Test
import MessagePack

test.case("EncodeBin8") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
    let expected = [0xc4, 0xff] + raw
    let encoded = try await MessagePack.encode(.binary(raw))
    expect(encoded == expected)
}

test.case("DecodeBin8") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
    let expected = MessagePack.binary(raw)
    let decoded = try await MessagePack.decode(bytes: [0xc4, 0xff] + raw)
    expect(decoded == expected)
}

test.case("EncodeBin16") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
    let expected = [0xc5, 0xff, 0xff] + raw
    let encoded = try await MessagePack.encode(.binary(raw))
    expect(encoded == expected)
}

test.case("DecodeBin16") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
    let expected = MessagePack.binary(raw)
    let decoded = try await MessagePack.decode(bytes: [0xc5, 0xff, 0xff] + raw)
    expect(decoded == expected)
}

test.case("EncodeBin32") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
    let expected = [0xc6, 0x00, 0x01, 0x00, 0x00] + raw
    let encoded = try await MessagePack.encode(.binary(raw))
    expect(encoded == expected)
}

test.case("DecodeBin32") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
    let expected = MessagePack.binary(raw)
    let decoded = try await MessagePack.decode(bytes: [0xc6, 0x00, 0x01, 0x00, 0x00] + raw)
    expect(decoded == expected)
}

test.case("EmptyBinary") {
    let binArray: [[UInt8]] = [
        [0xc4, 0x00],
        [0xc5, 0x00, 0x00],
        [0xc6, 0x00, 0x00, 0x00, 0x00]
    ]
    for bytes in binArray {
        let object = try await MessagePack.decode(bytes: bytes)
        expect(object.binaryValue == [])
    }
}

test.run()
