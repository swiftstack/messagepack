import Test
import MessagePack

test.case("Nil") {
    let expected = MessagePack.nil
    let value = MessagePack()
    expect(value == expected)
}

test.case("Bool") {
    let trueExpected = MessagePack.bool(true)
    let falseExpected = MessagePack.bool(false)
    let trueValue = MessagePack(true)
    let falseValue = MessagePack(false)
    expect(trueValue == trueExpected)
    expect(falseValue == falseExpected)
}

test.case("Float") {
    let expected = MessagePack.float(1.618)
    let value = MessagePack(Float(1.618))
    expect(value == expected)
}

test.case("Double") {
    let expected = MessagePack.double(1.618)
    let value = MessagePack(Double(1.618))
    expect(value == expected)
}

test.case("String") {
    let expected = MessagePack.string("Hello, World!")
    let value = MessagePack("Hello, World!")
    expect(value == expected)
}

test.case("Int") {
    let expected = MessagePack.int(Int.min)
    let value = MessagePack(Int.min)
    expect(value == expected)
    guard case .int = value else {
        fail("value is not .int type")
        return
    }
}

test.case("UInt") {
    let expected = MessagePack.uint(UInt.max)
    let value = MessagePack(UInt.max)
    expect(value == expected)
    guard case .uint = value else {
        fail("value is not .uint type")
        return
    }
}

test.case("Array") {
    let expected = MessagePack.array([.string("Hello"), .string("World")])
    let value = MessagePack([.string("Hello"), .string("World")])
    expect(value == expected)
}

test.case("Map") {
    let expected = MessagePack.map([.string("Hello"): .string("World")])
    let value = MessagePack([.string("Hello"): .string("World")])
    expect(value == expected)
}

test.case("Binary") {
    let expected = MessagePack.binary([0x01, 0x02, 0x03])
    let value = MessagePack([0x01, 0x02, 0x03] as [UInt8])
    expect(value == expected)
}

test.case("Extended") {
    let extended = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
    let expected = MessagePack.extended(extended)
    let value = MessagePack(extended)
    expect(value == expected)
}

test.run()
