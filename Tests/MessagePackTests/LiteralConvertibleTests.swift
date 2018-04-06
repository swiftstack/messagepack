import Test
import MessagePack

class LiteralConvertibleTests: TestCase {
    func testNilLiteralConvertible() {
        let expected = MessagePack.nil
        let value: MessagePack = nil
        assertEqual(value, expected)
    }

    func testBooleanLiteralConvertible() {
        let trueExpected = MessagePack.bool(true)
        let falseExpected = MessagePack.bool(false)
        let trueValue: MessagePack = true
        let falseValue: MessagePack = false
        assertEqual(trueValue, trueExpected)
        assertEqual(falseValue, falseExpected)
    }

    func testSignedIntegerLiteralConvertible() {
        let expected = MessagePack.int(-123)
        let value: MessagePack = -123
        assertEqual(value, expected)
        guard case .int = value else {
            fail("value is not .int type")
            return
        }
    }

    func testUnsignedIntegerLiteralConvertible() {
        let expected = MessagePack.uint(123)
        let value: MessagePack = 123
        assertEqual(value, expected)
        guard case .uint = value else {
            fail("value is not .uint type")
            return
        }
    }

    func testFloatLiteralConvertible() {
        let expected = MessagePack.double(1.618)
        let value: MessagePack = 1.618
        assertEqual(value, expected)
    }

    func testStringLiteralConvertible() {
        let expected = MessagePack.string("Hello, World!")
        let value: MessagePack = "Hello, World!"
        assertEqual(value, expected)
    }

    func testArrayLiteralConvertible() {
        let expected: MessagePack = [-1, 0, 1, 2]
        let value = MessagePack.array([
            MessagePack.int(-1),
            MessagePack.uint(0),
            MessagePack.uint(1),
            MessagePack.uint(2)])
        assertEqual(value, expected)
    }

    func testDictionaryLiteralConvertible() {
        let expected = MessagePack.map([.string("Hello"): .string("World")])
        let value: MessagePack = ["Hello": "World"]
        assertEqual(value, expected)
    }
}
