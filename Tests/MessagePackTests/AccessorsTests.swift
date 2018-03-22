import Test
import MessagePack

class AccessorsTests: TestCase {
    func testBool() {
        assertTrue(MessagePack(true).isBoolean)
        assertTrue(MessagePack(false).isBoolean)
        assertEqual(MessagePack(true).booleanValue, true)
        assertEqual(MessagePack(false).booleanValue, false)
    }

    func testFloat() {
        assertTrue(MessagePack.float(1.618).isFloat)
        assertFalse(MessagePack.float(1.618).isDouble)
        assertEqual(MessagePack.float(1.618).floatValue, 1.618)
    }

    func testDouble() {
        assertFalse(MessagePack.double(1.618).isFloat)
        assertTrue(MessagePack.double(1.618).isDouble)
        assertEqual(MessagePack.double(1.618).doubleValue, 1.618)
    }

    func testString() {
        assertTrue(MessagePack("Hello, World!").isString)
        assertEqual(MessagePack("Hello, World!").stringValue, "Hello, World!")
    }

    func testInt() {
        assertTrue(MessagePack(Int.min).isSigned)
        assertFalse(MessagePack(Int.min).isUnsigned)
        assertTrue(MessagePack(Int.min).isInteger)
        assertEqual(MessagePack(Int.min).integerValue, Int.min)
    }

    func testUInt() {
        assertFalse(MessagePack(UInt.max).isSigned)
        assertTrue(MessagePack(UInt.max).isUnsigned)
        assertTrue(MessagePack(UInt.max).isInteger)
        assertEqual(MessagePack(UInt.max).unsignedValue, UInt.max)
    }

    func testConversions() {
        assertNotNil(MessagePack.uint(1).integerValue)
        assertNotNil(MessagePack.int(1).unsignedValue)
        assertNil(MessagePack.uint(UInt.max).integerValue)
        assertNil(MessagePack.int(Int.min).unsignedValue)
    }

    func testBinary() {
        let expected: [UInt8] = [1,2,3]
        let encoded = MessagePack.binary(expected)
        assertTrue(encoded.isBinary)
        assertEqual(encoded.binaryValue, expected)
    }

    func testArray() {
        let expected: [MessagePack] = [1, 2.0, "three"]
        let encoded = MessagePack.array(expected)
        assertTrue(encoded.isArray)
        assertEqual(encoded.arrayValue, expected)
    }

    func testDictionary() {
        let expected: [MessagePack : MessagePack] = [1:2, 3:4]
        let encoded = MessagePack.map(expected)
        assertTrue(encoded.isDictionary)
        assertEqual(encoded.dictionaryValue, expected)
    }

    func testExtended() {
        let expected = MessagePack.Extended(type: 42, data: [1,2,3])
        let encoded = MessagePack.extended(expected)
        assertTrue(encoded.isExtended)
        assertEqual(encoded.extendedValue, expected)
    }
}
