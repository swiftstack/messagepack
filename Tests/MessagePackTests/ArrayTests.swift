import Test
import MessagePack

class ArrayTests: TestCase {
    func testEncodeFixArray() throws {
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]
        let encoded = try MessagePack.encode(.array([.int(1), .int(2), .int(3)]))
        expect(encoded == expected)
    }

    func testDecodeFixarray() throws {
        let expected = MessagePack.array([.uint(1), .uint(2), .uint(3)])
        let decoded = try MessagePack.decode(bytes: [0x93, 0x01, 0x02, 0x03])
        expect(decoded == expected)
    }

    func testEncodeArray16() throws {
        let expected = [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max))
        let encoded = try MessagePack.encode(.array([MessagePack](repeating: nil, count: Int(UInt16.max))))
        expect(encoded == expected)
    }

    func testDecodeArray16() throws {
        let expected = MessagePack.array([MessagePack](repeating: nil, count: Int(UInt16.max)))
        let decoded = try MessagePack.decode(bytes: [0xdc, 0xff, 0xff] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)))
        expect(decoded == expected)
    }

    func testEncodeArray32() throws {
        let expected = [0xdd, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1)
        let encoded = try MessagePack.encode(.array([MessagePack](repeating: nil, count: Int(UInt16.max)+1)))
        expect(encoded == expected)
    }

    func testDecodeArray32() throws {
        let expected = MessagePack.array([MessagePack](repeating: nil, count: Int(UInt16.max)+1))
        let decoded = try MessagePack.decode(bytes: [0xdd, 0x00, 0x01, 0x00, 0x00] + [UInt8](repeating: 0xc0, count: Int(UInt16.max)+1))
        expect(decoded == expected)
    }

    func testEmptyArray() throws {
        let arrayArray: [[UInt8]] = [
            [0x90],
            [0xdc, 0x00, 0x00],
            [0xdd, 0x00, 0x00, 0x00, 0x00]
        ]
        for bytes in arrayArray {
            let object = try MessagePack.decode(bytes: bytes)
            expect(object.arrayValue == [])
        }
    }

    func testFixArraySize() throws {
        let items = [MessagePack](repeating: .int(1), count: 15)
        let bytes = try MessagePack.encode(.array(items))
        expect(bytes.count == 16)
    }
}
