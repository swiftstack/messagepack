import Test
import MessagePack

test.case("EncodeFloat") {
    let expected: [UInt8] = [0xca, 0x3f, 0xcf, 0x1a, 0xa0]
    let encoded = try await MessagePack.encode(.float(1.618))
    expect(encoded == expected)
}

test.case("DecodeFloat") {
    let expected = MessagePack.float(1.618)
    let encoded: [UInt8] = [0xca, 0x3f, 0xcf, 0x1a, 0xa0]
    let decoded = try await MessagePack.decode(bytes: encoded)
    expect(decoded == expected)
}

test.case("EncodeDouble") {
    let expected: [UInt8] = [
        0xcb, 0x3f, 0xf9, 0xe3, 0x53, 0xf7, 0xce, 0xd9, 0x17
    ]
    let encoded = try await MessagePack.encode(.double(1.618))
    expect(encoded == expected)
}

test.case("DecodeDouble") {
    let expected = MessagePack.double(1.618)
    let encoded: [UInt8] = [
        0xcb, 0x3f, 0xf9, 0xe3, 0x53, 0xf7, 0xce, 0xd9, 0x17
    ]
    let decoded = try await MessagePack.decode(bytes: encoded)
    expect(decoded == expected)
}

test.run()
