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

    func testIntegerLiteralConvertible() {
        let expected = MessagePack.int(123)
        let value: MessagePack = 123
        assertEqual(value, expected)
        guard case .int = value else {
            fail("value is not .int type")
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
        let expected: MessagePack = [1, 2, 3]
        let value = MessagePack.array([.int(1), .int(2), .int(3)])
        assertEqual(value, expected)
    }

    func testDictionaryLiteralConvertible() {
        let expected = MessagePack.map([.string("Hello"): .string("World")])
        let value: MessagePack = ["Hello": "World"]
        assertEqual(value, expected)
    }
}
