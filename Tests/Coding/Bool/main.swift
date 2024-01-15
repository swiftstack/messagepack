import Test
import MessagePack

test("EncodeBoolFalse") {
    let expected: [UInt8] = [0xc2]
    let encoded = try await MessagePack.encode(.bool(false))
    expect(encoded == expected)
}

test("DecodeBoolFalse") {
    let expected = MessagePack.bool(false)
    let decoded = try await MessagePack.decode(bytes: [0xc2])
    expect(decoded == expected)
}

test("EncodeBoolTrue") {
    let expected: [UInt8] = [0xc3]
    let encoded = try await MessagePack.encode(.bool(true))
    expect(encoded == expected)
}

test("DecodeBoolTrue") {
    let expected = MessagePack.bool(true)
    let decoded = try await MessagePack.decode(bytes: [0xc3])
    expect(decoded == expected)
}

await run()
