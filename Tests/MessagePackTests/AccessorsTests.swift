import Test
import MessagePack

class AccessorsTests: TestCase {
    func testBool() {
        expect(MessagePack(true).isBoolean)
        expect(MessagePack(false).isBoolean)
        expect(MessagePack(true).booleanValue == true)
        expect(MessagePack(false).booleanValue == false)
    }

    func testFloat() {
        expect(MessagePack.float(1.618).isFloat)
        expect(!MessagePack.float(1.618).isDouble)
        expect(MessagePack.float(1.618).floatValue == 1.618)
    }

    func testDouble() {
        expect(!MessagePack.double(1.618).isFloat)
        expect(MessagePack.double(1.618).isDouble)
        expect(MessagePack.double(1.618).doubleValue == 1.618)
    }

    func testString() {
        expect(MessagePack("Hello, World!").isString)
        expect(MessagePack("Hello, World!").stringValue == "Hello, World!")
    }

    func testInt() {
        expect(MessagePack(Int.min).isSigned)
        expect(!MessagePack(Int.min).isUnsigned)
        expect(MessagePack(Int.min).isInteger)
        expect(MessagePack(Int.min).integerValue == Int.min)
    }

    func testUInt() {
        expect(!MessagePack(UInt.max).isSigned)
        expect(MessagePack(UInt.max).isUnsigned)
        expect(MessagePack(UInt.max).isInteger)
        expect(MessagePack(UInt.max).unsignedValue == UInt.max)
    }

    func testConversions() {
        expect(MessagePack.uint(1).integerValue != nil)
        expect(MessagePack.int(1).unsignedValue != nil)
        expect(MessagePack.uint(UInt.max).integerValue == nil)
        expect(MessagePack.int(Int.min).unsignedValue == nil)
    }

    func testBinary() {
        let expected: [UInt8] = [1,2,3]
        let encoded = MessagePack.binary(expected)
        expect(encoded.isBinary)
        expect(encoded.binaryValue == expected)
    }

    func testArray() {
        let expected: [MessagePack] = [1, 2.0, "three"]
        let encoded = MessagePack.array(expected)
        expect(encoded.isArray)
        expect(encoded.arrayValue == expected)
    }

    func testDictionary() {
        let expected: [MessagePack : MessagePack] = [1:2, 3:4]
        let encoded = MessagePack.map(expected)
        expect(encoded.isDictionary)
        expect(encoded.dictionaryValue == expected)
    }

    func testExtended() {
        let expected = MessagePack.Extended(type: 42, data: [1,2,3])
        let encoded = MessagePack.extended(expected)
        expect(encoded.isExtended)
        expect(encoded.extendedValue == expected)
    }
}
