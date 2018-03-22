import Test
import MessagePack

// TODO: test custom conformance instead
class MessagePackInitializableTests: TestCase {
    func testArray() {
        let packed = MessagePack.array([1, 2, 3])
        assertEqual(packed.arrayValue?[0], 1)
        assertEqual(packed.arrayValue?[1], 2)
        assertEqual(packed.arrayValue?[2], 3)
    }

    func testDictionary() {
        let packed = MessagePack.map(["Hello": "World"])
        assertEqual(packed.dictionaryValue?["Hello"], "World")
    }

    func testBinary() {
        let packed = MessagePack.binary([0x01, 0x02, 0x03])
        assertEqual(packed.binaryValue, [0x01, 0x02, 0x03])
    }

    func testExtended() {
        let original = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let packed = MessagePack.extended(original)
        assertEqual(packed.extendedValue?.type, 1)
        assertEqual(packed.extendedValue?.data, [0x01, 0x02, 0x03])
    }

    func testArrayOfInt() {
        let packed = MessagePack.array([1, 2, 3])
        assertEqual(packed.arrayValue?[0], 1)
        assertEqual(packed.arrayValue?[1], 2)
        assertEqual(packed.arrayValue?[2], 3)
    }

    func testArrayOfString() {
        let packed = MessagePack.array(["one", "two", "three"])
        assertEqual(packed.arrayValue?[0], "one")
        assertEqual(packed.arrayValue?[1], "two")
        assertEqual(packed.arrayValue?[2], "three")
    }
}
