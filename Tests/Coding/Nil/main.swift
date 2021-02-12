import Test
import MessagePack

test.case("EncodeNil") {
    let expected: [UInt8] = [0xc0]
    let encoded = try await MessagePack.encode(.nil)
    expect(encoded == expected)
}

test.case("DecodeNil") {
    let expected = MessagePack.nil
    let decoded = try await MessagePack.decode(bytes: [0xc0])
    expect(decoded == expected)
}

test.run()
