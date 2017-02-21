import XCTest
import MessagePack

class StringEncodingTests: XCTestCase {
    func testEnglishString() {
        let original = MessagePack.string("Hello, World!")
        let result = try? MessagePack.decode(bytes: MessagePack.encode(original))
        XCTAssertEqual(result, original)
    }

    func testSwedishString() {
        let original = MessagePack.string("Hellö, Wörld!")
        let result = try? MessagePack.decode(bytes: MessagePack.encode(original))
        XCTAssertEqual(result, original)
    }

    func testJapaneseString() {
        let original = MessagePack.string("こんにちは世界！")
        let result = try? MessagePack.decode(bytes: MessagePack.encode(original))
        XCTAssertEqual(result, original)
    }

    func testRussianString() {
        let original = MessagePack.string("Привет, Мир!")
        let result = try? MessagePack.decode(bytes: MessagePack.encode(original))
        XCTAssertEqual(result, original)
    }

    func testASCIIString() {
        let string = MessagePack.string("Hello, World!")
        let bytes: [UInt8] = [0xad, 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21]

        let encoded = MessagePack.encode(string)
        XCTAssertEqual(encoded, bytes)

        let decoded = try? MessagePack.decode(bytes: bytes)
        XCTAssertEqual(decoded, string)
    }
}
