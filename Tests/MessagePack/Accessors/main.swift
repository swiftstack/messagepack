import Test
import MessagePack

test.case("Bool") {
    expect(MessagePack(true).isBoolean)
    expect(MessagePack(false).isBoolean)
    expect(MessagePack(true).booleanValue == true)
    expect(MessagePack(false).booleanValue == false)
}

test.case("Float") {
    expect(MessagePack.float(1.618).isFloat)
    expect(!MessagePack.float(1.618).isDouble)
    expect(MessagePack.float(1.618).floatValue == 1.618)
}

test.case("Double") {
    expect(!MessagePack.double(1.618).isFloat)
    expect(MessagePack.double(1.618).isDouble)
    expect(MessagePack.double(1.618).doubleValue == 1.618)
}

test.case("String") {
    expect(MessagePack("Hello, World!").isString)
    expect(MessagePack("Hello, World!").stringValue == "Hello, World!")
}

test.case("Int") {
    expect(MessagePack(Int.min).isSigned)
    expect(!MessagePack(Int.min).isUnsigned)
    expect(MessagePack(Int.min).isInteger)
    expect(MessagePack(Int.min).integerValue == Int.min)
}

test.case("UInt") {
    expect(!MessagePack(UInt.max).isSigned)
    expect(MessagePack(UInt.max).isUnsigned)
    expect(MessagePack(UInt.max).isInteger)
    expect(MessagePack(UInt.max).unsignedValue == UInt.max)
}

test.case("Conversions") {
    expect(MessagePack.uint(1).integerValue != nil)
    expect(MessagePack.int(1).unsignedValue != nil)
    expect(MessagePack.uint(UInt.max).integerValue == nil)
    expect(MessagePack.int(Int.min).unsignedValue == nil)
}

test.case("Binary") {
    let expected: [UInt8] = [1,2,3]
    let encoded = MessagePack.binary(expected)
    expect(encoded.isBinary)
    expect(encoded.binaryValue == expected)
}

test.case("Array") {
    let expected: [MessagePack] = [1, 2.0, "three"]
    let encoded = MessagePack.array(expected)
    expect(encoded.isArray)
    expect(encoded.arrayValue == expected)
}

test.case("Dictionary") {
    let expected: [MessagePack : MessagePack] = [1:2, 3:4]
    let encoded = MessagePack.map(expected)
    expect(encoded.isDictionary)
    expect(encoded.dictionaryValue == expected)
}

test.case("Extended") {
    let expected = MessagePack.Extended(type: 42, data: [1,2,3])
    let encoded = MessagePack.extended(expected)
    expect(encoded.isExtended)
    expect(encoded.extendedValue == expected)
}
test.run()
