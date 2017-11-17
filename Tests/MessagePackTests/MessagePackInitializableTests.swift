import Test
import MessagePack

class MessagePackInitializableTests: TestCase {
    func testArray() {
        let packed = MessagePack.array([1, 2, 3])
        guard let array = [MessagePack](packed) else {
            fail()
            return
        }
        assertEqual(array[0], 1)
        assertEqual(array[1], 2)
        assertEqual(array[2], 3)
    }

    func testDictionary() {
        let packed = MessagePack.map(["Hello": "World"])
        guard let map = [MessagePack : MessagePack](packed) else {
            fail()
            return
        }
        assertEqual(map["Hello"]!, "World")
    }

    func testBinary() {
        let packed = MessagePack.binary([0x01, 0x02, 0x03])
        guard let binary = [UInt8](packed) else {
            fail()
            return
        }
        assertEqual(binary, [0x01, 0x02, 0x03])
    }

    func testExtended() {
        let original = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let packed = MessagePack.extended(original)
        guard let extended = MessagePack.Extended(packed) else {
            fail()
            return
        }
        assertEqual(extended.type, 1)
        assertEqual(extended.data, [0x01, 0x02, 0x03])
    }

    func testArrayOfInt() {
        let packed = MessagePack.array([1, 2, 3])
        guard let array = [Int](packed) else {
            fail()
            return
        }
        assertEqual(array[0], 1)
        assertEqual(array[1], 2)
        assertEqual(array[2], 3)
    }

    func testArrayOfString() {
        let packed: MessagePack? = MessagePack.array(["one", "two", "three"])
        guard let array = [String](packed) else {
            fail()
            return
        }
        assertEqual(array[0], "one")
        assertEqual(array[1], "two")
        assertEqual(array[2], "three")
    }
}
