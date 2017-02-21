import MessagePack

class ConveniencePropertiesTests: TestCase {
    func testNilProperty() {
        let nilValue = MessagePack.nil
        assertTrue(nilValue.isNil)
        assertFalse(MessagePack.int(0).isNil)
        assertFalse(MessagePack.string("").isNil)
        assertFalse(MessagePack.float(0).isNil)
        assertFalse(MessagePack.double(0).isNil)
        assertFalse(MessagePack.array([]).isNil)
        assertFalse(MessagePack.map([:]).isNil)
        assertFalse(MessagePack.binary([]).isNil)
        assertFalse(MessagePack.extended(MessagePack.Extended(type: 0, data: [])).isNil)
    }

    func testArrayProperty() {
        guard let array = MessagePack.array([1, 2, 3]).array else {
            fail("array property shouldn't be nil")
            return
        }
        assertEqual(array[0], 1)
        assertEqual(array[1], 2)
        assertEqual(array[2], 3)
    }

    func testMapProperty() {
        guard let map = MessagePack.map(["Hello": "World"]).map else {
            fail("map property shouldn't be nil")
            return
        }
        assertEqual(map["Hello"]!, "World")
    }

    func testBinaryProperty() {
        guard let binary = MessagePack.binary([0x01, 0x02, 0x03]).binary else {
            fail("binary property shouldn't be nil")
            return
        }
        assertEqual(binary, [0x01, 0x02, 0x03])
    }

    func testExtendedProperty() {
        let extended = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        guard let encoded = MessagePack.extended(extended).extended else {
            fail("extended property shouldn't be nil")
            return
        }
        assertEqual(encoded.type, 1)
        assertEqual(encoded.data, [0x01, 0x02, 0x03])
    }
}
