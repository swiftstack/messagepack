import Test
import MessagePack

class BinaryTests: TestCase {
    func testEncodeBin8() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
        let expected = [0xc4, 0xff] + raw
        let encoded = MessagePack.encode(.binary(raw))
        assertEqual(encoded, expected)
    }

    func testDecodeBin8() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
        let expected = MessagePack.binary(raw)
        let decoded = try? MessagePack.decode(bytes: [0xc4, 0xff] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeBin16() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
        let expected = [0xc5, 0xff, 0xff] + raw
        let encoded = MessagePack.encode(.binary(raw))
        assertEqual(encoded, expected)
    }

    func testDecodeBin16() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
        let expected = MessagePack.binary(raw)
        let decoded = try? MessagePack.decode(bytes: [0xc5, 0xff, 0xff] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeBin32() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
        let expected = [0xc6, 0x00, 0x01, 0x00, 0x00] + raw
        let encoded = MessagePack.encode(.binary(raw))
        assertEqual(encoded, expected)
    }

    func testDecodeBin32() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
        let expected = MessagePack.binary(raw)
        let decoded = try? MessagePack.decode(bytes: [0xc6, 0x00, 0x01, 0x00, 0x00] + raw)
        assertEqual(decoded, expected)
    }

    func testEmptyBinary() {
        let binArray: [[UInt8]] = [
            [0xc4, 0x00],
            [0xc5, 0x00, 0x00],
            [0xc6, 0x00, 0x00, 0x00, 0x00],
        ]
        for bytes in binArray {
            guard let object = try? MessagePack.decode(bytes: bytes),
                let binary = [UInt8](object) else {
                    fail()
                    return
            }
            assertEqual(binary, [])
        }
    }
}
