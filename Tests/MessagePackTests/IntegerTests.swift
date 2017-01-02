import XCTest
import MessagePack

class IntegerTests: XCTestCase {
    func testSerializerNegativeIntToFixInt() {
        let expected: [UInt8] = [0xff]
        let packed = MessagePack.serialize(.int(-1))
        XCTAssertEqual(packed, expected)
    }

    func testSerializerPositiveIntToFixInt() {
        let expected: [UInt8] = [0x01]
        let packed = MessagePack.serialize(.uint(1))
        XCTAssertEqual(packed, expected)
    }

    func testSerializerInt() {
        let expected: [UInt8] = MemoryLayout<Int>.size == MemoryLayout<Int64>.size ?
            [0xd3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]:
            [0xd2, 0x80, 0x00, 0x00, 0x00]

        let packed = MessagePack.serialize(.int(Int.min))
        XCTAssertEqual(packed, expected)
    }

    func testSerializerUInt() {
        let expected: [UInt8] = MemoryLayout<Int>.size == MemoryLayout<Int64>.size ?
            [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]:
            [0xce, 0xff, 0xff, 0xff, 0xff]

        let packed = MessagePack.serialize(.uint(UInt.max))
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerNegativeFixInt() {
        let expected = MessagePack.int(-1)
        let unpacked = try? MessagePack.deserialize(bytes: [0xff])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .int = value else {
            XCTFail("unpacked value is not type of .int")
            return
        }
    }

    func testDeserializerPositiveFixInt() {
        let expected = MessagePack.uint(1)
        let unpacked = try? MessagePack.deserialize(bytes: [0x01])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .uint = value else {
            XCTFail("unpacked value is not type of .uint")
            return
        }
    }

    func testDeserializerNegativeInt8() {
        let expected = MessagePack(Int8.min)
        let unpacked = try? MessagePack.deserialize(bytes: [0xd0, 0x80])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .int = value else {
            XCTFail("unpacked value is not type of .int")
            return
        }
    }

    func testDeserializerNegativeInt16() {
        let expected = MessagePack(Int16.min)
        let unpacked = try? MessagePack.deserialize(bytes: [0xd1, 0x80, 0x00])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .int = value else {
            XCTFail("unpacked value is not type of .int")
            return
        }
    }

    func testDeserializerNegativeInt32() {
        let expected = MessagePack(Int32.min)
        let unpacked = try? MessagePack.deserialize(bytes: [0xd2, 0x80, 0x00, 0x00, 0x00])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .int = value else {
            XCTFail("unpacked value is not type of .int")
            return
        }
    }

    func testDeserializerNegativeInt64() {
        let expected = MessagePack(Int64.min)
        let unpacked = try? MessagePack.deserialize(bytes: [0xd3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .int = value else {
            XCTFail("unpacked value is not type of .int")
            return
        }
    }

    func testDeserializerUInt8() {
        let expected = MessagePack(UInt8.max)
        let unpacked = try? MessagePack.deserialize(bytes: [0xcc, 0xff])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .uint = value else {
            XCTFail("unpacked value is not type of .uint")
            return
        }
    }

    func testDeserializerUInt16() {
        let expected = MessagePack(UInt16.max)
        let unpacked = try? MessagePack.deserialize(bytes: [0xcd, 0xff, 0xff])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .uint = value else {
            XCTFail("unpacked value is not type of .uint")
            return
        }
    }

    func testDeserializerUInt32() {
        let expected = MessagePack(UInt32.max)
        let unpacked = try? MessagePack.deserialize(bytes: [0xce, 0xff, 0xff, 0xff, 0xff])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .uint = value else {
            XCTFail("unpacked value is not type of .uint")
            return
        }
    }

    func testDeserializerUInt64() {
        let expected = MessagePack(UInt64.max)
        let unpacked = try? MessagePack.deserialize(bytes: [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
        XCTAssertEqual(unpacked, expected)
        guard let value = unpacked, case .uint = value else {
            XCTFail("unpacked value is not type of .uint")
            return
        }
    }
}
