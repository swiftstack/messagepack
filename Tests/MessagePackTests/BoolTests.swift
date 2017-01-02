import XCTest
import MessagePack

class BoolTests: XCTestCase {
    func testSerializerBoolFalse() {
        let expected: [UInt8] = [0xc2]
        let packed = MessagePack.serialize(.bool(false))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerBoolFalse() {
        let expected = MessagePack.bool(false)
        let unpacked = try? MessagePack.deserialize(bytes: [0xc2])
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerBoolTrue() {
        let expected: [UInt8] = [0xc3]
        let packed = MessagePack.serialize(.bool(true))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerBoolTrue() {
        let expected = MessagePack.bool(true)
        let unpacked = try? MessagePack.deserialize(bytes: [0xc3])
        XCTAssertEqual(unpacked, expected)
    }
}
