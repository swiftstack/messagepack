import MessagePack

class MessagePackInitializableTests: TestCase {
    func testArray() {
        let packed = MessagePack.array([1, 2, 3])
        guard let array = [MessagePack](packed) else {
            fail("array initializer have failed")
            return
        }
        assertEqual(array[0], 1)
        assertEqual(array[1], 2)
        assertEqual(array[2], 3)
    }

    func testDictionary() {
        let packed = MessagePack.map(["Hello": "World"])
        guard let map = [MessagePack : MessagePack](packed) else {
            fail("map initializer have failed")
            return
        }
        assertEqual(map["Hello"]!, "World")
    }

    func testBinary() {
        let packed = MessagePack.binary([0x01, 0x02, 0x03])
        guard let binary = [UInt8](packed) else {
            fail("[UInt8] initializer have failed")
            return
        }
        assertEqual(binary, [0x01, 0x02, 0x03])
    }

    func testExtended() {
        let original = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let packed = MessagePack.extended(original)
        guard let extended = MessagePack.Extended(packed) else {
            fail("extended initializer have failed")
            return
        }
        assertEqual(extended.type, 1)
        assertEqual(extended.data, [0x01, 0x02, 0x03])
    }
}
