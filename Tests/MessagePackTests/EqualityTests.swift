import XCTest
import MessagePack

class EqualityTests: XCTestCase {
    func testNilEquality() {
        XCTAssertTrue(MessagePack.nil == MessagePack.nil)
        XCTAssertFalse(MessagePack.nil == MessagePack.bool(false))
        XCTAssertFalse(MessagePack.nil == MessagePack.float(1.618))
        XCTAssertFalse(MessagePack.nil == MessagePack.double(1.618))
        XCTAssertFalse(MessagePack.nil == MessagePack.int(1))
        XCTAssertFalse(MessagePack.nil == MessagePack.uint(1))
    }

    func testIntEquality() {
        XCTAssertTrue(MessagePack.int(1) == MessagePack.int(1))
        XCTAssertTrue(MessagePack.int(1) == MessagePack.uint(1))
    }

    func testUIntEquality() {
        XCTAssertTrue(MessagePack.uint(1) == MessagePack.int(1))
        XCTAssertTrue(MessagePack.uint(1) == MessagePack.uint(1))
    }

    func testBoolEquality() {
        XCTAssertTrue(MessagePack.bool(true) == MessagePack.bool(true))
        XCTAssertTrue(MessagePack.bool(false) == MessagePack.bool(false))
        XCTAssertFalse(MessagePack.bool(true) == MessagePack.bool(false))
        XCTAssertFalse(MessagePack.bool(false) == MessagePack.bool(true))
    }

    func testFloatEquality() {
        XCTAssertTrue(MessagePack.float(1.618) == MessagePack.float(1.618))
        XCTAssertTrue(MessagePack.double(1.618) == MessagePack.double(1.618))
        XCTAssertFalse(MessagePack.float(1.618) == MessagePack.double(1.618))
        XCTAssertFalse(MessagePack.double(1.618) == MessagePack.float(1.618))
    }

    func testStringEquality() {
        let helloWorld = "Hello, world!"
        XCTAssertTrue(MessagePack.string(helloWorld) == MessagePack.string(helloWorld))
    }

    func testArrayEquality() {
        XCTAssertTrue(MessagePack.array([0, 1, 2, 3]) == MessagePack.array([0, 1, 2, 3]))
    }

    func testMapEquality() {
        let array: [MessagePack: MessagePack] = ["zero": 0, "one": 1, "two": 2, "three": 3]
        XCTAssertTrue(MessagePack.map(array) == MessagePack.map(array))
    }

    func testBinaryEquality() {
        let array: [UInt8] = [0x00, 0x01, 0x02, 0x03]
        XCTAssertTrue(MessagePack.binary(array) == MessagePack.binary(array))
    }

    func testExtendedEquality() {
        let extended = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03, 0xff])
        XCTAssertTrue(MessagePack.extended(extended) == MessagePack.extended(extended))
    }
}
