import XCTest
import MessagePack

class LiteralConvertibleTests: XCTestCase {
    func testNilLiteralConvertible() {
        let expected = MessagePack.nil
        let value: MessagePack = nil
        XCTAssertEqual(value, expected)
    }

    func testBooleanLiteralConvertible() {
        let trueExpected = MessagePack.bool(true)
        let falseExpected = MessagePack.bool(false)
        let trueValue: MessagePack = true
        let falseValue: MessagePack = false
        XCTAssertEqual(trueValue, trueExpected)
        XCTAssertEqual(falseValue, falseExpected)
    }

    func testIntegerLiteralConvertible() {
        let expected = MessagePack.int(123)
        let value: MessagePack = 123
        XCTAssertEqual(value, expected)
        guard case .int = value else {
            XCTFail("value is not .int type")
            return
        }
    }

    func testFloatLiteralConvertible() {
        let expected = MessagePack.double(1.618)
        let value: MessagePack = 1.618
        XCTAssertEqual(value, expected)
    }

    func testStringLiteralConvertible() {
        let expected = MessagePack.string("Hello, World!")
        let value: MessagePack = "Hello, World!"
        XCTAssertEqual(value, expected)
    }

    func testArrayLiteralConvertible() {
        let expected: MessagePack = [1, 2, 3]
        let value = MessagePack.array([.int(1), .int(2), .int(3)])
        XCTAssertEqual(value, expected)
    }

    func testDictionaryLiteralConvertible() {
        let expected = MessagePack.map([.string("Hello"): .string("World")])
        let value: MessagePack = ["Hello": "World"]
        XCTAssertEqual(value, expected)
    }
}
