import MessagePack

class ExtendedTests: TestCase {
    func testEncodeFixExt1() {
        let raw = [UInt8](repeating: 0x45, count: 1)
        let expected: [UInt8] = [0xd4, 0x01] + raw
        let encoded = MessagePack.encode(.extended(MessagePack.Extended(type: 1, data: raw)))
        assertEqual(encoded, expected)
    }

    func testDecodeFixExt1() {
        let raw = [UInt8](repeating: 0x45, count: 1)
        let expected = MessagePack.extended(MessagePack.Extended(type: 1, data: raw))
        let decoded = try? MessagePack.decode(bytes: [0xd4, 0x01] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeFixExt2() {
        let raw = [UInt8](repeating: 0x45, count: 2)
        let expected: [UInt8] = [0xd5, 0x01] + raw
        let encoded = MessagePack.encode(.extended(MessagePack.Extended(type: 1, data: raw)))
        assertEqual(encoded, expected)
    }

    func testDecodeFixExt2() {
        let raw = [UInt8](repeating: 0x45, count: 2)
        let expected = MessagePack.extended(MessagePack.Extended(type: 1, data: raw))
        let decoded = try? MessagePack.decode(bytes: [0xd5, 0x01] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeFixExt4() {
        let raw = [UInt8](repeating: 0x45, count: 4)
        let expected: [UInt8] = [0xd6, 0x01] + raw
        let encoded = MessagePack.encode(.extended(MessagePack.Extended(type: 1, data: raw)))
        assertEqual(encoded, expected)
    }

    func testDecodeFixExt4() {
        let raw = [UInt8](repeating: 0x45, count: 4)
        let expected = MessagePack.extended(MessagePack.Extended(type: 1, data: raw))
        let decoded = try? MessagePack.decode(bytes: [0xd6, 0x01] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeFixExt8() {
        let raw = [UInt8](repeating: 0x45, count: 8)
        let expected: [UInt8] = [0xd7, 0x01] + raw
        let encoded = MessagePack.encode(.extended(MessagePack.Extended(type: 1, data: raw)))
        assertEqual(encoded, expected)
    }

    func testDecodeFixExt8() {
        let raw = [UInt8](repeating: 0x45, count: 8)
        let expected = MessagePack.extended(MessagePack.Extended(type: 1, data: raw))
        let decoded = try? MessagePack.decode(bytes: [0xd7, 0x01] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeFixExt16() {
        let raw = [UInt8](repeating: 0x45, count: 16)
        let expected: [UInt8] = [0xd8, 0x01] + raw
        let encoded = MessagePack.encode(.extended(MessagePack.Extended(type: 1, data: raw)))
        assertEqual(encoded, expected)
    }

    func testDecodeFixExt16() {
        let raw = [UInt8](repeating: 0x45, count: 16)
        let expected = MessagePack.extended(MessagePack.Extended(type: 1, data: raw))
        let decoded = try? MessagePack.decode(bytes: [0xd8, 0x01] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeExt8() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
        let expected: [UInt8] = [0xc7, 0xff, 0x01] + raw
        let encoded = MessagePack.encode(.extended(MessagePack.Extended(type: 1, data: raw)))
        assertEqual(encoded, expected)
    }

    func testDecodeExt8() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt8.max))
        let expected = MessagePack.extended(MessagePack.Extended(type: 1, data: raw))
        let decoded = try? MessagePack.decode(bytes: [0xc7, 0xff, 0x01] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeExt16() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
        let expected: [UInt8] = [0xc8, 0xff, 0xff, 0x01] + raw
        let encoded = MessagePack.encode(.extended(MessagePack.Extended(type: 1, data: raw)))
        assertEqual(encoded, expected)
    }

    func testDecodeExt16() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max))
        let expected = MessagePack.extended(MessagePack.Extended(type: 1, data: raw))
        let decoded = try? MessagePack.decode(bytes: [0xc8, 0xff, 0xff, 0x01] + raw)
        assertEqual(decoded, expected)
    }

    func testEncodeExt32() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
        let expected: [UInt8] = [0xc9, 0x00, 0x01, 0x00, 0x00, 0x01] + raw
        let encoded = MessagePack.encode(.extended(MessagePack.Extended(type: 1, data: raw)))
        assertEqual(encoded, expected)
    }

    func testDecodeExt32() {
        let raw = [UInt8](repeating: 0x45, count: Int(UInt16.max)+1)
        let expected = MessagePack.extended(MessagePack.Extended(type: 1, data: raw))
        let decoded = try? MessagePack.decode(bytes: [0xc9, 0x00, 0x01, 0x00, 0x00, 0x01] + raw)
        assertEqual(decoded, expected)
    }
}
