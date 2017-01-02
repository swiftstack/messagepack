import XCTest
import MessagePack

class ConvenienceInitializersTests: XCTestCase {
    func testNil() {
        let expected = MessagePack.nil
        let value = MessagePack()
        XCTAssertEqual(value, expected)
    }

    func testBool() {
        let trueExpected = MessagePack.bool(true)
        let falseExpected = MessagePack.bool(false)
        let trueValue = MessagePack(true)
        let falseValue = MessagePack(false)
        XCTAssertEqual(trueValue, trueExpected)
        XCTAssertEqual(falseValue, falseExpected)
    }

    func testFloat() {
        let expected = MessagePack.float(1.618)
        let value = MessagePack(Float(1.618))
        XCTAssertEqual(value, expected)
    }

    func testDouble() {
        let expected = MessagePack.double(1.618)
        let value = MessagePack(Double(1.618))
        XCTAssertEqual(value, expected)
    }

    func testString() {
        let expected = MessagePack.string("Hello, World!")
        let value = MessagePack("Hello, World!")
        XCTAssertEqual(value, expected)
    }

    func testInt() {
        let expected = MessagePack.int(Int.min)
        let value = MessagePack(Int.min)
        XCTAssertEqual(value, expected)
        guard case .int = value else {
            XCTFail("value is not .int type")
            return
        }
    }

    func testUInt() {
        let expected = MessagePack.uint(UInt.max)
        let value = MessagePack(UInt.max)
        XCTAssertEqual(value, expected)
        guard case .uint = value else {
            XCTFail("value is not .uint type")
            return
        }
    }

    func testArray() {
        let expected = MessagePack.array([.string("Hello"), .string("World")])
        let value = MessagePack([.string("Hello"), .string("World")])
        XCTAssertEqual(value, expected)
    }

    func testMap() {
        let expected = MessagePack.map([.string("Hello"): .string("World")])
        let value = MessagePack([.string("Hello"): .string("World")])
        XCTAssertEqual(value, expected)
    }

    func testBinary() {
        let expected = MessagePack.binary([0x01, 0x02, 0x03])
        let value = MessagePack([0x01, 0x02, 0x03] as [UInt8])
        XCTAssertEqual(value, expected)
    }

    func testExtended() {
        let extended = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let expected = MessagePack.extended(extended)
        let value = MessagePack(extended)
        XCTAssertEqual(value, expected)
    }
}
