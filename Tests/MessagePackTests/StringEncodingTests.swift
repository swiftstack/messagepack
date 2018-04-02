import Test
import MessagePack

class StringEncodingTests: TestCase {
    func testEnglishString() {
        scope {
            let original = MessagePack.string("Hello, World!")
            let encoded = try MessagePack.encode(original)
            let result = try MessagePack.decode(bytes: encoded)
            assertEqual(result, original)
        }
    }

    func testSwedishString() {
        scope {
            let original = MessagePack.string("Hellö, Wörld!")
            let encoded = try MessagePack.encode(original)
            let result = try MessagePack.decode(bytes: encoded)
            assertEqual(result, original)
        }
    }

    func testJapaneseString() {
        scope {
            let original = MessagePack.string("こんにちは世界！")
            let encoded = try MessagePack.encode(original)
            let result = try MessagePack.decode(bytes: encoded)
            assertEqual(result, original)
        }
    }

    func testRussianString() {
        scope {
            let original = MessagePack.string("Привет, Мир!")
            let encoded = try MessagePack.encode(original)
            let result = try MessagePack.decode(bytes: encoded)
            assertEqual(result, original)
        }
    }

    func testASCIIString() {
        scope {
            let string = MessagePack.string("Hello, World!")

            let bytes: [UInt8] = [
                0xad, 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20,
                0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21
            ]

            let encoded = try MessagePack.encode(string)
            assertEqual(encoded, bytes)

            let decoded = try MessagePack.decode(bytes: bytes)
            assertEqual(decoded, string)
        }
    }
}
