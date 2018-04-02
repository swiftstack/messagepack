import Test
import MessagePack

class NilTests: TestCase {
    func testEncodeNil() {
        scope {
            let expected: [UInt8] = [0xc0]
            let encoded = try MessagePack.encode(.nil)
            assertEqual(encoded, expected)
        }
    }

    func testDecodeNil() {
        scope {
            let expected = MessagePack.nil
            let decoded = try MessagePack.decode(bytes: [0xc0])
            assertEqual(decoded, expected)
        }
    }

    func testHasValue() {
        scope {
            let nilValue = MessagePack.nil
            assertFalse(nilValue.hasValue)
            assertTrue(MessagePack.int(0).hasValue)
            assertTrue(MessagePack.string("").hasValue)
            assertTrue(MessagePack.float(0).hasValue)
            assertTrue(MessagePack.double(0).hasValue)
            assertTrue(MessagePack.array([]).hasValue)
            assertTrue(MessagePack.map([:]).hasValue)
            assertTrue(MessagePack.binary([]).hasValue)
            assertTrue(MessagePack.extended(MessagePack.Extended(
                type: 0, data: [])).hasValue)
        }
    }
}
