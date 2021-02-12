import Test
import MessagePack

test.case("EncodeFixExt1") {
    let raw = [UInt8](repeating: 0x45, count: 1)
    let expected: [UInt8] = [0xd4, 0x01] + raw
    let encoded = try await MessagePack.encode(.extended(
        MessagePack.Extended(type: 1, data: raw)))
    expect(encoded == expected)
}

test.case("DecodeFixExt1") {
    let raw = [UInt8](repeating: 0x45, count: 1)
    let expected = MessagePack.extended(
        MessagePack.Extended(type: 1, data: raw))
    let decoded = try await MessagePack.decode(bytes: [0xd4, 0x01] + raw)
    expect(decoded == expected)
}

test.case("EncodeFixExt2") {
    let raw = [UInt8](repeating: 0x45, count: 2)
    let expected: [UInt8] = [0xd5, 0x01] + raw
    let encoded = try await MessagePack.encode(.extended(
        MessagePack.Extended(type: 1, data: raw)))
    expect(encoded == expected)
}

test.case("DecodeFixExt2") {
    let raw = [UInt8](repeating: 0x45, count: 2)
    let expected = MessagePack.extended(
        MessagePack.Extended(type: 1, data: raw))
    let decoded = try await MessagePack.decode(bytes: [0xd5, 0x01] + raw)
    expect(decoded == expected)
}

test.case("EncodeFixExt4") {
    let raw = [UInt8](repeating: 0x45, count: 4)
    let expected: [UInt8] = [0xd6, 0x01] + raw
    let encoded = try await MessagePack.encode(.extended(
        MessagePack.Extended(type: 1, data: raw)))
    expect(encoded == expected)
}

test.case("DecodeFixExt4") {
    let raw = [UInt8](repeating: 0x45, count: 4)
    let expected = MessagePack.extended(
        MessagePack.Extended(type: 1, data: raw))
    let decoded = try await MessagePack.decode(bytes: [0xd6, 0x01] + raw)
    expect(decoded == expected)
}

test.case("EncodeFixExt8") {
    let raw = [UInt8](repeating: 0x45, count: 8)
    let expected: [UInt8] = [0xd7, 0x01] + raw
    let encoded = try await MessagePack.encode(.extended(
        MessagePack.Extended(type: 1, data: raw)))
    expect(encoded == expected)
}

test.case("DecodeFixExt8") {
    let raw = [UInt8](repeating: 0x45, count: 8)
    let expected = MessagePack.extended(
        MessagePack.Extended(type: 1, data: raw))
    let decoded = try await MessagePack.decode(bytes: [0xd7, 0x01] + raw)
    expect(decoded == expected)
}

test.case("EncodeFixExt16") {
    let raw = [UInt8](repeating: 0x45, count: 16)
    let expected: [UInt8] = [0xd8, 0x01] + raw
    let encoded = try await MessagePack.encode(.extended(
        MessagePack.Extended(type: 1, data: raw)))
    expect(encoded == expected)
}

test.case("DecodeFixExt16") {
    let raw = [UInt8](repeating: 0x45, count: 16)
    let expected = MessagePack.extended(
        MessagePack.Extended(type: 1, data: raw))
    let decoded = try await MessagePack.decode(bytes: [0xd8, 0x01] + raw)
    expect(decoded == expected)
}

test.case("EncodeExt8") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
    let expected: [UInt8] = [0xc7, 0xff, 0x01] + raw
    let encoded = try await MessagePack.encode(.extended(
        MessagePack.Extended(type: 1, data: raw)))
    expect(encoded == expected)
}

test.case("DecodeExt8") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
    let expected = MessagePack.extended(
        MessagePack.Extended(type: 1, data: raw))
    let decoded = try await MessagePack.decode(
        bytes: [0xc7, 0xff, 0x01] + raw)
    expect(decoded == expected)
}

test.case("EncodeExt16") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
    let expected: [UInt8] = [0xc8, 0xff, 0xff, 0x01] + raw
    let encoded = try await MessagePack.encode(.extended(
        MessagePack.Extended(type: 1, data: raw)))
    expect(encoded == expected)
}

test.case("DecodeExt16") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
    let expected = MessagePack.extended(
        MessagePack.Extended(type: 1, data: raw))
    let decoded = try await MessagePack.decode(
        bytes: [0xc8, 0xff, 0xff, 0x01] + raw)
    expect(decoded == expected)
}

test.case("EncodeExt32") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
    let expected: [UInt8] = [0xc9, 0x00, 0x01, 0x00, 0x00, 0x01] + raw
    let encoded = try await MessagePack.encode(.extended(
        MessagePack.Extended(type: 1, data: raw)))
    expect(encoded == expected)
}

test.case("DecodeExt32") {
    let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
    let expected = MessagePack.extended(
        MessagePack.Extended(type: 1, data: raw))
    let decoded = try await MessagePack.decode(
        bytes: [0xc9, 0x00, 0x01, 0x00, 0x00, 0x01] + raw)
    expect(decoded == expected)
}

test.run()
