import MessagePack

class NilTests: TestCase {
    func testEncodeNil() {
        let expected: [UInt8] = [0xc0]
        let encoded = MessagePack.encode(.nil)
        assertEqual(encoded, expected)
    }

    func testDecodeNil() {
        let expected = MessagePack.nil
        let decoded = try? MessagePack.decode(bytes: [0xc0])
        assertEqual(decoded, expected)
    }
}
