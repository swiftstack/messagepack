import Test
import MessagePack

class StringTests: TestCase {
    func testEncodeFixStr() {
        let expected = [0xaa] + [UInt8](repeating: 0x20, count: 0x0a)
        let string = String(repeating: " ", count: 0x0a)
        let encoded = try? MessagePack.encode(.string(string))
        assertEqual(encoded ?? [], expected)
    }

    func testDecodeFixStr() {
        let expected = MessagePack.string(String(repeating: " ", count: 0x0a))
        let encoded = [0xaa] + [UInt8](repeating: 0x20, count: 0x0a)
        let decoded = try? MessagePack.decode(bytes: encoded)
        assertEqual(decoded, expected)
    }

    func testEncodeStr8() {
        let expected = [0xd9, 0xff] + [UInt8](repeating: 0x20, count: Int(UInt8.max))
        let string = String(repeating: " ", count: Int(UInt8.max))
        let encoded = try? MessagePack.encode(.string(string))
        assertEqual(encoded ?? [], expected)
    }

    func testDecodeStr8() {
        let expected = MessagePack.string(String(repeating: " ", count: Int(UInt8.max)))
        let encoded = [0xd9, 0xff] + [UInt8](repeating: 0x20, count: Int(UInt8.max))
        let decoded = try? MessagePack.decode(bytes: encoded)
        assertEqual(decoded, expected)
    }

    func testEncodeStr16() {
        let expected = [0xda, 0xff, 0xff] + [UInt8](repeating: 0x20, count: Int(UInt16.max))
        let string = String(repeating: " ", count: Int(UInt16.max))
        let encoded = try? MessagePack.encode(.string(string))
        assertEqual(encoded ?? [], expected)
    }

    func testDecodeStr16() {
        let expected = MessagePack.string(String(repeating: " ", count: Int(UInt16.max)))
        let encoded = [0xda, 0xff, 0xff] + [UInt8](repeating: 0x20, count: Int(UInt16.max))
        let decoded = try? MessagePack.decode(bytes: encoded)
        assertEqual(decoded, expected)
    }

    func testEncodeStr32() {
        let expected = [0xdb, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0x20, count: Int(UInt16.max) + 1)
        let string = String(repeating: " ", count: Int(UInt16.max) + 1)
        let encoded = try? MessagePack.encode(.string(string))
        assertEqual(encoded ?? [], expected)
    }

    func testDecodeStr32() {
        let expected = MessagePack.string(String(repeating: " ", count: Int(UInt16.max) + 1))
        let encoded = [0xdb, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0x20, count: Int(UInt16.max) + 1)
        let decoded = try? MessagePack.decode(bytes: encoded)
        assertEqual(decoded, expected)
    }
}
