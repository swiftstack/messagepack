import MessagePack

class HashValueTests: TestCase {
    func testNilHashValue() {
        assertEqual(MessagePack.nil.hashValue, 0)
    }

    func testIntHashValue() {
        assertEqual(MessagePack.int(Int.min).hashValue, Int.min.hashValue)
        assertEqual(MessagePack.int(Int.max).hashValue, Int.max.hashValue)
    }

    func testUIntHashValue() {
        assertEqual(MessagePack.uint(UInt.min).hashValue, UInt.min.hashValue)
        assertEqual(MessagePack.uint(UInt.max).hashValue, UInt.max.hashValue)
    }

    func testBoolHashValue() {
        assertEqual(MessagePack.bool(true).hashValue, true.hashValue)
        assertEqual(MessagePack.bool(false).hashValue, false.hashValue)
    }

    func testFloatHashValue() {
        assertEqual(MessagePack.float(1.618).hashValue, Float(1.618).hashValue)
        assertEqual(MessagePack.float(3.14).hashValue, Float(3.14).hashValue)
    }

    func testDoubleHashValue() {
        assertEqual(MessagePack.double(1.618).hashValue, Double(1.618).hashValue)
        assertEqual(MessagePack.double(3.14).hashValue, Double(3.14).hashValue)
    }

    func testStringHashValue() {
        assertEqual(MessagePack.string("Hello, World!").hashValue, "Hello, World!".hashValue)
    }

    func testBinaryHashValue() {
        let first = MessagePack.binary([0x00, 0x01, 0x02, 0x03])
        let second = MessagePack.binary([0x00, 0x01, 0x02, 0x03])
        assertNotEqual(first.hashValue, 0)
        assertEqual(first.hashValue, second.hashValue)
    }

    func testArrayHashValue() {
        let unpackedArray: [MessagePack] = [0, 1, 2, 3]
        let packedArray = MessagePack.array([0, 1, 2, 3])
        assertNotEqual(unpackedArray.hashValue, 0)
        assertEqual(unpackedArray.hashValue, packedArray.hashValue)
    }

    func testMapHashValue() {
        let packedMap = MessagePack.map(["zero": 0, "one": 1, "two": 2, "three": 3])
        let unpackedMap: [MessagePack : MessagePack] = ["zero": 0, "one": 1, "two": 2, "three": 3]
        assertNotEqual(unpackedMap.hashValue, 0)
        assertEqual(unpackedMap.hashValue, packedMap.hashValue)
    }

    func testExtendedHashValue() {
        let firstExtended = MessagePack.Extended(type: 1, data: [0x00, 0x01, 0x02, 0x03])
        let secondExtended = MessagePack.Extended(type: 1, data: [0x00, 0x01, 0x02, 0x03])
        let first = MessagePack.extended(firstExtended)
        let second = MessagePack.extended(secondExtended)
        assertNotEqual(firstExtended.hashValue, 0)
        assertNotEqual(first.hashValue, 0)
        assertEqual(firstExtended.hashValue, secondExtended.hashValue)
        assertEqual(first.hashValue, second.hashValue)
    }
}
