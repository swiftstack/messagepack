import Test
import MessagePack

class InitTests: TestCase {
    func testByteStream() {
        let expected: MessagePack = [1,2,3]
        let bytes: [UInt8] = [0x93, 0x01, 0x02, 0x03]
        var reader = MessagePackReader(InputByteStream(bytes))
        guard let decoded = try? reader.decode() as MessagePack else {
            fail("decode error")
            return
        }
        assertEqual(decoded, expected)
    }
}
