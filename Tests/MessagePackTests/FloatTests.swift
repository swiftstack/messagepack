import XCTest
import MessagePack

class FloatTests: XCTestCase {
    func testSerializerFloat() {
        let expected: [UInt8] = [0xca, 0x3f, 0xcf, 0x1a, 0xa0]
        let packed = MessagePack.serialize(.float(1.618))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerFloat() {
        let expected = MessagePack.float(1.618)
        let packed: [UInt8] = [0xca, 0x3f, 0xcf, 0x1a, 0xa0]
        let unpacked = try? MessagePack.deserialize(bytes: packed)
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerDouble() {
        let expected: [UInt8] = [0xcb, 0x3f, 0xf9, 0xe3, 0x53, 0xf7, 0xce, 0xd9, 0x17]
        let packed = MessagePack.serialize(.double(1.618))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerDouble() {
        let expected = MessagePack.double(1.618)
        let packed: [UInt8] = [0xcb, 0x3f, 0xf9, 0xe3, 0x53, 0xf7, 0xce, 0xd9, 0x17]
        let unpacked = try? MessagePack.deserialize(bytes: packed)
        XCTAssertEqual(unpacked, expected)
    }
}
