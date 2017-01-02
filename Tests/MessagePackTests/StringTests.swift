import XCTest
import MessagePack

class StringTests: XCTestCase {
    func testSerializerFixStr() {
        let expected = [0xaa] + [UInt8](repeating: 0x20, count: 0x0a)
        let string = String(repeating: " ", count: 0x0a)
        let packed = MessagePack.serialize(.string(string))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerFixStr() {
        let expected = MessagePack.string(String(repeating: " ", count: 0x0a))
        let packed = [0xaa] + [UInt8](repeating: 0x20, count: 0x0a)
        let unpacked = try? MessagePack.deserialize(bytes: packed)
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerStr8() {
        let expected = [0xd9, 0xff] + [UInt8](repeating: 0x20, count: Int(UInt8.max))
        let string = String(repeating: " ", count: Int(UInt8.max))
        let packed = MessagePack.serialize(.string(string))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerStr8() {
        let expected = MessagePack.string(String(repeating: " ", count: Int(UInt8.max)))
        let packed = [0xd9, 0xff] + [UInt8](repeating: 0x20, count: Int(UInt8.max))
        let unpacked = try? MessagePack.deserialize(bytes: packed)
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerStr16() {
        let expected = [0xda, 0xff, 0xff] + [UInt8](repeating: 0x20, count: Int(UInt16.max))
        let string = String(repeating: " ", count: Int(UInt16.max))
        let packed = MessagePack.serialize(.string(string))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerStr16() {
        let expected = MessagePack.string(String(repeating: " ", count: Int(UInt16.max)))
        let packed = [0xda, 0xff, 0xff] + [UInt8](repeating: 0x20, count: Int(UInt16.max))
        let unpacked = try? MessagePack.deserialize(bytes: packed)
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerStr32() {
        let expected = [0xdb, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0x20, count: Int(UInt16.max) + 1)
        let string = String(repeating: " ", count: Int(UInt16.max) + 1)
        let packed = MessagePack.serialize(.string(string))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerStr32() {
        let expected = MessagePack.string(String(repeating: " ", count: Int(UInt16.max) + 1))
        let packed = [0xdb, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0x20, count: Int(UInt16.max) + 1)
        let unpacked = try? MessagePack.deserialize(bytes: packed)
        XCTAssertEqual(unpacked, expected)
    }
}
