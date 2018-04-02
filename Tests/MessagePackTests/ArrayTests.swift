import Test
import MessagePack

class ArrayTests: TestCase {
    func testEncodeFixArray() {
        scope {
            let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]
            let encoded = try MessagePack.encode(.array([.int(1), .int(2), .int(3)]))
            assertEqual(encoded, expected)
        }
    }

    func testDecodeFixarray() {
        scope {
            let expected = MessagePack.array([.int(1), .int(2), .int(3)])
            let decoded = try MessagePack.decode(bytes: [0x93, 0x01, 0x02, 0x03])
            assertEqual(decoded, expected)
        }
    }

    func testEncodeArray16() {
        scope {
            let expected = [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max))
            let encoded = try MessagePack.encode(.array([MessagePack](repeating: nil, count: Int(UInt16.max))))
            assertEqual(encoded, expected)
        }
    }

    func testDecodeArray16() {
        scope {
            let expected = MessagePack.array([MessagePack](repeating: nil, count: Int(UInt16.max)))
            let decoded = try MessagePack.decode(bytes: [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)))
            assertEqual(decoded, expected)
        }
    }

    func testEncodeArray32() {
        scope {
            let expected = [0xdd, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1)
            let encoded = try MessagePack.encode(.array([MessagePack](repeating: nil, count: Int(UInt16.max)+1)))
            assertEqual(encoded, expected)
        }
    }

    func testDecodeArray32() {
        scope {
            let expected = MessagePack.array([MessagePack](repeating: nil, count: Int(UInt16.max)+1))
            let decoded = try MessagePack.decode(bytes: [0xdd, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1))
            assertEqual(decoded, expected)
        }
    }

    func testEmptyArray() {
        scope {
            let arrayArray: [[UInt8]] = [
                [0x90],
                [0xdc, 0x00, 0x00],
                [0xdd, 0x00, 0x00, 0x00, 0x00]
            ]
            for bytes in arrayArray {
                let object = try MessagePack.decode(bytes: bytes)
                assertEqual(object.arrayValue, [])
            }
        }
    }

    func testFixArraySize() {
        scope {
            let items = [MessagePack](repeating: .int(1), count: 15)
            let bytes = try MessagePack.encode(.array(items))
            assertEqual(bytes.count, 16)
        }
    }
}
