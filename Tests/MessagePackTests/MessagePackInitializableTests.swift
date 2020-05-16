import Test
import MessagePack

// TODO: test custom conformance instead
class MessagePackInitializableTests: TestCase {
    func testArray() {
        let packed = MessagePack.array([1, 2, 3])
        expect(packed.arrayValue?[0] == 1)
        expect(packed.arrayValue?[1] == 2)
        expect(packed.arrayValue?[2] == 3)
    }

    func testDictionary() {
        let packed = MessagePack.map(["Hello": "World"])
        expect(packed.dictionaryValue?["Hello"] == "World")
    }

    func testBinary() {
        let packed = MessagePack.binary([0x01, 0x02, 0x03])
        expect(packed.binaryValue == [0x01, 0x02, 0x03])
    }

    func testExtended() {
        let original = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let packed = MessagePack.extended(original)
        expect(packed.extendedValue?.type == 1)
        expect(packed.extendedValue?.data == [0x01, 0x02, 0x03])
    }

    func testArrayOfInt() {
        let packed = MessagePack.array([1, 2, 3])
        expect(packed.arrayValue?[0] == 1)
        expect(packed.arrayValue?[1] == 2)
        expect(packed.arrayValue?[2] == 3)
    }

    func testArrayOfString() {
        let packed = MessagePack.array(["one", "two", "three"])
        expect(packed.arrayValue?[0] == "one")
        expect(packed.arrayValue?[1] == "two")
        expect(packed.arrayValue?[2] == "three")
    }
}
