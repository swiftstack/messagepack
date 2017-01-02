import XCTest
import MessagePack

class ArrayTests: XCTestCase {
    func testSerializerFixArray() {
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]
        let packed = MessagePack.serialize(.array([.int(1), .int(2), .int(3)]))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerFixarray() {
        let expected = MessagePack.array([.int(1), .int(2), .int(3)])
        let unpacked = try? MessagePack.deserialize(bytes: [0x93, 0x01, 0x02, 0x03])
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerArray16() {
        let expected = [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max))
        let packed = MessagePack.serialize(.array([MessagePack](repeating: nil, count: Int(UInt16.max))))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerArray16() {
        let expected = MessagePack.array([MessagePack](repeating: nil, count: Int(UInt16.max)))
        let unpacked = try? MessagePack.deserialize(bytes: [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)))
        XCTAssertEqual(unpacked, expected)
    }

    func testSerializerArray32() {
        let expected = [0xdd, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1)
        let packed = MessagePack.serialize(.array([MessagePack](repeating: nil, count: Int(UInt16.max)+1)))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerArray32() {
        let expected = MessagePack.array([MessagePack](repeating: nil, count: Int(UInt16.max)+1))
        let unpacked = try? MessagePack.deserialize(bytes: [0xdd, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1))
        XCTAssertEqual(unpacked, expected)
    }

    func testEmptyArray() {
        let arrayArray: [[UInt8]] = [
            [0x90],
            [0xdc, 0x00, 0x00],
            [0xdd, 0x00, 0x00, 0x00, 0x00]
        ]
        for bytes in arrayArray {
            if let empty = try? MessagePack.deserialize(bytes: bytes) {
                XCTAssertEqual(empty.array!, [])
            } else {
                XCTFail("deserialize failed")
            }
        }
    }
}
