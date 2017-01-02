import XCTest
import MessagePack

class BinaryTests: XCTestCase {
    func testSerializerBin8() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
        let expected = [0xc4, 0xff] + raw
        let packed = MessagePack.serialize(.binary(raw))
        XCTAssertEqual(packed, expected)

    }

    func testDeserializerBin8() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
        let expected = MessagePack.binary(raw)
        let unpacked = try? MessagePack.deserialize(bytes: [0xc4, 0xff] + raw)
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerBin16() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
        let expected = [0xc5, 0xff, 0xff] + raw
        let packed = MessagePack.serialize(.binary(raw))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerBin16() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
        let expected = MessagePack.binary(raw)
        let unpacked = try? MessagePack.deserialize(bytes: [0xc5, 0xff, 0xff] + raw)
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerBin32() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
        let expected = [0xc6, 0x00, 0x01, 0x00, 0x00] + raw
        let packed = MessagePack.serialize(.binary(raw))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerBin32() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
        let expected = MessagePack.binary(raw)
        let unpacked = try? MessagePack.deserialize(bytes: [0xc6, 0x00, 0x01, 0x00, 0x00] + raw)
        XCTAssertEqual(unpacked, expected)
    }

    func testEmptyBinary() {
        let binArray: [[UInt8]] = [
            [0xc4, 0x00],
            [0xc5, 0x00, 0x00],
            [0xc6, 0x00, 0x00, 0x00, 0x00],
        ]
        for bytes in binArray {
            if let empty = try? MessagePack.deserialize(bytes: bytes) {
                XCTAssertEqual(empty.binary!, [])
            } else {
                XCTFail("deserialize failed")
            }
        }
    }
}
