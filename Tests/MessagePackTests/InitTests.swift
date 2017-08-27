import Test
import MessagePack

class InitTests: TestCase {
    func testUnsafeBufferPointer() {
        let expected: MessagePack = [1,2,3]
        let bytes: [UInt8] = [0x93, 0x01, 0x02, 0x03]
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        var decoder = UnsafeMessagePackDecoder(buffer: buffer)
        guard let decoded = try? decoder.decode() as MessagePack else {
            fail("decode error")
            return
        }
        assertEqual(decoded, expected)
    }

    func testUnsafePointer() {
        let expected: MessagePack = [1,2,3]
        let bytes: [UInt8] = [0x93, 0x01, 0x02, 0x03]
        var decoder = UnsafeMessagePackDecoder(bytes: UnsafeRawPointer(bytes), count: 4)
        guard let decoded = try? decoder.decode() as MessagePack else {
            fail("decode error")
            return
        }
        assertEqual(decoded, expected)
    }
}
