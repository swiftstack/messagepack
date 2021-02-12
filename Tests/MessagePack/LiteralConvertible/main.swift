import Test
import MessagePack

test.case("NilLiteralConvertible") {
    let expected = MessagePack.nil
    let value: MessagePack = nil
    expect(value == expected)
}

test.case("BooleanLiteralConvertible") {
    let trueExpected = MessagePack.bool(true)
    let falseExpected = MessagePack.bool(false)
    let trueValue: MessagePack = true
    let falseValue: MessagePack = false
    expect(trueValue == trueExpected)
    expect(falseValue == falseExpected)
}

test.case("SignedIntegerLiteralConvertible") {
    let expected = MessagePack.int(-123)
    let value: MessagePack = -123
    expect(value == expected)
    guard case .int = value else {
        fail("value is not .int type")
        return
    }
}

test.case("UnsignedIntegerLiteralConvertible") {
    let expected = MessagePack.uint(123)
    let value: MessagePack = 123
    expect(value == expected)
    guard case .uint = value else {
        fail("value is not .uint type")
        return
    }
}

test.case("FloatLiteralConvertible") {
    let expected = MessagePack.double(1.618)
    let value: MessagePack = 1.618
    expect(value == expected)
}

test.case("StringLiteralConvertible") {
    let expected = MessagePack.string("Hello, World!")
    let value: MessagePack = "Hello, World!"
    expect(value == expected)
}

test.case("ArrayLiteralConvertible") {
    let expected: MessagePack = [-1, 0, 1, 2]
    let value = MessagePack.array([
        MessagePack.int(-1),
        MessagePack.uint(0),
        MessagePack.uint(1),
        MessagePack.uint(2)])
    expect(value == expected)
}

test.case("DictionaryLiteralConvertible") {
    let expected = MessagePack.map([.string("Hello"): .string("World")])
    let value: MessagePack = ["Hello": "World"]
    expect(value == expected)
}
test.run()
