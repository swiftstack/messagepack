import Test
import MessagePack

class FloatTests: TestCase {
    func testEncodeFloat() {
        let expected: [UInt8] = [0xca, 0x3f, 0xcf, 0x1a, 0xa0]
        let encoded = MessagePack.encode(.float(1.618))
        assertEqual(encoded, expected)
    }

    func testDecodeFloat() {
        let expected = MessagePack.float(1.618)
        let encoded: [UInt8] = [0xca, 0x3f, 0xcf, 0x1a, 0xa0]
        let decoded = try? MessagePack.decode(bytes: encoded)
        assertEqual(decoded, expected)
    }

    func testEncodeDouble() {
        let expected: [UInt8] = [0xcb, 0x3f, 0xf9, 0xe3, 0x53, 0xf7, 0xce, 0xd9, 0x17]
        let encoded = MessagePack.encode(.double(1.618))
        assertEqual(encoded, expected)
    }

    func testDecodeDouble() {
        let expected = MessagePack.double(1.618)
        let encoded: [UInt8] = [0xcb, 0x3f, 0xf9, 0xe3, 0x53, 0xf7, 0xce, 0xd9, 0x17]
        let decoded = try? MessagePack.decode(bytes: encoded)
        assertEqual(decoded, expected)
    }
}
