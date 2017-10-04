import Test
import MessagePack

class InitTests: TestCase {
    func testUnsafeBufferPointer() {
        let expected: MessagePack = [1,2,3]
        let bytes: [UInt8] = [0x93, 0x01, 0x02, 0x03]
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        var reader = MessagePackReader(buffer: buffer)
        guard let decoded = try? reader.decode() as MessagePack else {
            fail("decode error")
            return
        }
        assertEqual(decoded, expected)
    }

    func testUnsafePointer() {
        let expected: MessagePack = [1,2,3]
        let bytes: [UInt8] = [0x93, 0x01, 0x02, 0x03]
        var reader = MessagePackReader(bytes: UnsafeRawPointer(bytes), count: 4)
        guard let decoded = try? reader.decode() as MessagePack else {
            fail("decode error")
            return
        }
        assertEqual(decoded, expected)
    }
}
