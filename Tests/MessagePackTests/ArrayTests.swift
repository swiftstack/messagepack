import Test
import MessagePack

class ArrayTests: TestCase {
    func testEncodeFixArray() {
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]
        let encoded = MessagePack.encode(.array([.int(1), .int(2), .int(3)]))
        assertEqual(encoded, expected)
    }

    func testDecodeFixarray() {
        let expected = MessagePack.array([.int(1), .int(2), .int(3)])
        let decoded = try? MessagePack.decode(bytes: [0x93, 0x01, 0x02, 0x03])
        assertEqual(decoded, expected)
    }

    func testEncodeArray16() {
        let expected = [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max))
        let encoded = MessagePack.encode(.array([MessagePack](repeating: nil, count: Int(UInt16.max))))
        assertEqual(encoded, expected)
    }

    func testDecodeArray16() {
        let expected = MessagePack.array([MessagePack](repeating: nil, count: Int(UInt16.max)))
        let decoded = try? MessagePack.decode(bytes: [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)))
        assertEqual(decoded, expected)
    }

    func testEncodeArray32() {
        let expected = [0xdd, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1)
        let encoded = MessagePack.encode(.array([MessagePack](repeating: nil, count: Int(UInt16.max)+1)))
        assertEqual(encoded, expected)
    }

    func testDecodeArray32() {
        let expected = MessagePack.array([MessagePack](repeating: nil, count: Int(UInt16.max)+1))
        let decoded = try? MessagePack.decode(bytes: [0xdd, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1))
        assertEqual(decoded, expected)
    }

    func testEmptyArray() {
        let arrayArray: [[UInt8]] = [
            [0x90],
            [0xdc, 0x00, 0x00],
            [0xdd, 0x00, 0x00, 0x00, 0x00]
        ]
        for bytes in arrayArray {
            guard let object = try? MessagePack.decode(bytes: bytes),
                let array = [MessagePack](object) else {
                    fail()
                    return
            }
            assertEqual(array, [])
        }
    }

    func testFixArraySize() {
        let items = [MessagePack](repeating: .int(1), count: 15)
        let bytes = MessagePack.encode(.array(items))
        assertEqual(bytes.count, 16)
    }
}
