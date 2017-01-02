import XCTest
import MessagePack

class HashValueTests: XCTestCase {
    func testNilHashValue() {
        XCTAssertEqual(MessagePack.nil.hashValue, 0)
    }

    func testIntHashValue() {
        XCTAssertEqual(MessagePack.int(Int.min).hashValue, Int.min.hashValue)
        XCTAssertEqual(MessagePack.int(Int.max).hashValue, Int.max.hashValue)
    }

    func testUIntHashValue() {
        XCTAssertEqual(MessagePack.uint(UInt.min).hashValue, UInt.min.hashValue)
        XCTAssertEqual(MessagePack.uint(UInt.max).hashValue, UInt.max.hashValue)
    }

    func testBoolHashValue() {
        XCTAssertEqual(MessagePack.bool(true).hashValue, true.hashValue)
        XCTAssertEqual(MessagePack.bool(false).hashValue, false.hashValue)
    }

    func testFloatHashValue() {
        XCTAssertEqual(MessagePack.float(1.618).hashValue, Float(1.618).hashValue)
        XCTAssertEqual(MessagePack.float(3.14).hashValue, Float(3.14).hashValue)
    }

    func testDoubleHashValue() {
        XCTAssertEqual(MessagePack.double(1.618).hashValue, Double(1.618).hashValue)
        XCTAssertEqual(MessagePack.double(3.14).hashValue, Double(3.14).hashValue)
    }

    func testStringHashValue() {
        XCTAssertEqual(MessagePack.string("Hello, World!").hashValue, "Hello, World!".hashValue)
    }

    func testBinaryHashValue() {
        let first = MessagePack.binary([0x00, 0x01, 0x02, 0x03])
        let second = MessagePack.binary([0x00, 0x01, 0x02, 0x03])
        XCTAssertNotEqual(first.hashValue, 0)
        XCTAssertEqual(first.hashValue, second.hashValue)
    }

    func testArrayHashValue() {
        let first = MessagePack.array([0, 1, 2, 3])
        let second = MessagePack.array([0, 1, 2, 3])
        XCTAssertNotEqual(first.hashValue, 0)
        XCTAssertEqual(first.hashValue, second.hashValue)
    }

    func testMapHashValue() {
        let first = MessagePack.map(["zero": 0, "one": 1, "two": 2, "three": 3])
        let second = MessagePack.map(["zero": 0, "one": 1, "two": 2, "three": 3])
        XCTAssertNotEqual(first.hashValue, 0)
        XCTAssertEqual(first.hashValue, second.hashValue)
    }

    func testExtendedHashValue() {
        let firstExtended = MessagePack.Extended(type: 1, data: [0x00, 0x01, 0x02, 0x03])
        let secondExtended = MessagePack.Extended(type: 1, data: [0x00, 0x01, 0x02, 0x03])
        let first = MessagePack.extended(firstExtended)
        let second = MessagePack.extended(secondExtended)
        XCTAssertNotEqual(firstExtended.hashValue, 0)
        XCTAssertNotEqual(first.hashValue, 0)
        XCTAssertEqual(firstExtended.hashValue, secondExtended.hashValue)
        XCTAssertEqual(first.hashValue, second.hashValue)
    }
}
