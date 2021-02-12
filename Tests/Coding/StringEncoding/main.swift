import Test
import MessagePack

test.case("EnglishString") {
    let original = MessagePack.string("Hello, World!")
    let encoded = try await MessagePack.encode(original)
    let result = try await MessagePack.decode(bytes: encoded)
    expect(result == original)
}

test.case("SwedishString") {
    let original = MessagePack.string("Hellö, Wörld!")
    let encoded = try await MessagePack.encode(original)
    let result = try await MessagePack.decode(bytes: encoded)
    expect(result == original)
}

test.case("JapaneseString") {
    let original = MessagePack.string("こんにちは世界！")
    let encoded = try await MessagePack.encode(original)
    let result = try await MessagePack.decode(bytes: encoded)
    expect(result == original)
}

test.case("RussianString") {
    let original = MessagePack.string("Привет, Мир!")
    let encoded = try await MessagePack.encode(original)
    let result = try await MessagePack.decode(bytes: encoded)
    expect(result == original)
}

test.case("ASCIIString") {
    let string = MessagePack.string("Hello, World!")

    let bytes: [UInt8] = [
        0xad, 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20,
        0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21
    ]

    let encoded = try await MessagePack.encode(string)
    expect(encoded == bytes)

    let decoded = try await MessagePack.decode(bytes: bytes)
    expect(decoded == string)
}

test.run()
