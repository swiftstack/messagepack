import Test
import MessagePack

test.case("EncodeNegativeIntToFixInt") {
    let expected: [UInt8] = [0xff]
    let encoded = try await MessagePack.encode(.int(-1))
    expect(encoded == expected)
}

test.case("EncodePositiveIntToFixInt") {
    let expected: [UInt8] = [0x01]
    let encoded = try await MessagePack.encode(.uint(1))
    expect(encoded == expected)
}

test.case("EncodeInt") {
    let expected: [UInt8] = MemoryLayout<Int>.size == MemoryLayout<Int64>.size ?
        [0xd3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]:
        [0xd2, 0x80, 0x00, 0x00, 0x00]

    let encoded = try await MessagePack.encode(.int(Int.min))
    expect(encoded == expected)
}

test.case("EncodeUInt") {
    let expected: [UInt8] = MemoryLayout<Int>.size == MemoryLayout<Int64>.size ?
        [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]:
        [0xce, 0xff, 0xff, 0xff, 0xff]

    let encoded = try await MessagePack.encode(.uint(UInt.max))
    expect(encoded == expected)
}

test.case("DecodeNegativeFixInt") {
    let expected = MessagePack.int(-1)
    let decoded = try await MessagePack.decode(bytes: [0xff])
    expect(decoded == expected)
    guard case .int = decoded else {
        fail("decoded value is not type of .int")
        return
    }
}

test.case("DecodePositiveFixInt") {
    let expected = MessagePack.uint(1)
    let decoded = try await MessagePack.decode(bytes: [0x01])
    expect(decoded == expected)
    guard case .uint = decoded else {
        fail("decoded value is not type of .uint")
        return
    }
}

test.case("DecodeNegativeInt8") {
    let expected = MessagePack(Int8.min)
    let decoded = try await MessagePack.decode(bytes: [0xd0, 0x80])
    expect(decoded == expected)
    guard case .int = decoded else {
        fail("decoded value is not type of .int")
        return
    }
}

test.case("DecodeNegativeInt16") {
    let expected = MessagePack(Int16.min)
    let decoded = try await MessagePack.decode(bytes: [0xd1, 0x80, 0x00])
    expect(decoded == expected)
    guard case .int = decoded else {
        fail("decoded value is not type of .int")
        return
    }
}

test.case("DecodeNegativeInt32") {
    let expected = MessagePack(Int32.min)
    let decoded = try await MessagePack.decode(
        bytes: [0xd2, 0x80, 0x00, 0x00, 0x00])
    expect(decoded == expected)
    guard case .int = decoded else {
        fail("decoded value is not type of .int")
        return
    }
}

test.case("DecodeNegativeInt64") {
    let expected = MessagePack(Int64.min)
    let decoded = try await MessagePack.decode(
        bytes: [0xd3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
    expect(decoded == expected)
    guard case .int = decoded else {
        fail("decoded value is not type of .int")
        return
    }
}

test.case("DecodeUInt8") {
    let expected = MessagePack(UInt8.max)
    let decoded = try await MessagePack.decode(bytes: [0xcc, 0xff])
    expect(decoded == expected)
    guard case .uint = decoded else {
        fail("decoded value is not type of .uint")
        return
    }
}

test.case("DecodeUInt16") {
    let expected = MessagePack(UInt16.max)
    let decoded = try await MessagePack.decode(bytes: [0xcd, 0xff, 0xff])
    expect(decoded == expected)
    guard case .uint = decoded else {
        fail("decoded value is not type of .uint")
        return
    }
}

test.case("DecodeUInt32") {
    let expected = MessagePack(UInt32.max)
    let decoded = try await MessagePack.decode(
        bytes: [0xce, 0xff, 0xff, 0xff, 0xff])
    expect(decoded == expected)
    guard case .uint = decoded else {
        fail("decoded value is not type of .uint")
        return
    }
}

test.case("DecodeUInt64") {
    let expected = MessagePack(UInt64.max)
    let decoded = try await MessagePack.decode(
        bytes: [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
    expect(decoded == expected)
    guard case .uint = decoded else {
        fail("decoded value is not type of .uint")
        return
    }
}

test.run()
