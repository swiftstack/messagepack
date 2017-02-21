import MessagePack

class ConvenienceInitializersTests: TestCase {
    func testNil() {
        let expected = MessagePack.nil
        let value = MessagePack()
        assertEqual(value, expected)
    }

    func testBool() {
        let trueExpected = MessagePack.bool(true)
        let falseExpected = MessagePack.bool(false)
        let trueValue = MessagePack(true)
        let falseValue = MessagePack(false)
        assertEqual(trueValue, trueExpected)
        assertEqual(falseValue, falseExpected)
    }

    func testFloat() {
        let expected = MessagePack.float(1.618)
        let value = MessagePack(Float(1.618))
        assertEqual(value, expected)
    }

    func testDouble() {
        let expected = MessagePack.double(1.618)
        let value = MessagePack(Double(1.618))
        assertEqual(value, expected)
    }

    func testString() {
        let expected = MessagePack.string("Hello, World!")
        let value = MessagePack("Hello, World!")
        assertEqual(value, expected)
    }

    func testInt() {
        let expected = MessagePack.int(Int.min)
        let value = MessagePack(Int.min)
        assertEqual(value, expected)
        guard case .int = value else {
            fail("value is not .int type")
            return
        }
    }

    func testUInt() {
        let expected = MessagePack.uint(UInt.max)
        let value = MessagePack(UInt.max)
        assertEqual(value, expected)
        guard case .uint = value else {
            fail("value is not .uint type")
            return
        }
    }

    func testArray() {
        let expected = MessagePack.array([.string("Hello"), .string("World")])
        let value = MessagePack([.string("Hello"), .string("World")])
        assertEqual(value, expected)
    }

    func testMap() {
        let expected = MessagePack.map([.string("Hello"): .string("World")])
        let value = MessagePack([.string("Hello"): .string("World")])
        assertEqual(value, expected)
    }

    func testBinary() {
        let expected = MessagePack.binary([0x01, 0x02, 0x03])
        let value = MessagePack([0x01, 0x02, 0x03] as [UInt8])
        assertEqual(value, expected)
    }

    func testExtended() {
        let extended = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let expected = MessagePack.extended(extended)
        let value = MessagePack(extended)
        assertEqual(value, expected)
    }
}
