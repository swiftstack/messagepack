import Test
import MessagePack

class IntegerTests: TestCase {
    func testEncodeNegativeIntToFixInt() {
        let expected: [UInt8] = [0xff]
        let encoded = MessagePack.encode(.int(-1))
        assertEqual(encoded, expected)
    }

    func testEncodePositiveIntToFixInt() {
        let expected: [UInt8] = [0x01]
        let encoded = MessagePack.encode(.uint(1))
        assertEqual(encoded, expected)
    }

    func testEncodeInt() {
        let expected: [UInt8] = MemoryLayout<Int>.size == MemoryLayout<Int64>.size ?
            [0xd3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]:
            [0xd2, 0x80, 0x00, 0x00, 0x00]

        let encoded = MessagePack.encode(.int(Int.min))
        assertEqual(encoded, expected)
    }

    func testEncodeUInt() {
        let expected: [UInt8] = MemoryLayout<Int>.size == MemoryLayout<Int64>.size ?
            [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]:
            [0xce, 0xff, 0xff, 0xff, 0xff]

        let encoded = MessagePack.encode(.uint(UInt.max))
        assertEqual(encoded, expected)
    }

    func testDecodeNegativeFixInt() {
        let expected = MessagePack.int(-1)
        let decoded = try? MessagePack.decode(bytes: [0xff])
        assertEqual(decoded, expected)
        guard let value = decoded, case .int = value else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodePositiveFixInt() {
        let expected = MessagePack.uint(1)
        let decoded = try? MessagePack.decode(bytes: [0x01])
        assertEqual(decoded, expected)
        guard let value = decoded, case .uint = value else {
            fail("decoded value is not type of .uint")
            return
        }
    }

    func testDecodeNegativeInt8() {
        let expected = MessagePack(Int8.min)
        let decoded = try? MessagePack.decode(bytes: [0xd0, 0x80])
        assertEqual(decoded, expected)
        guard let value = decoded, case .int = value else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodeNegativeInt16() {
        let expected = MessagePack(Int16.min)
        let decoded = try? MessagePack.decode(bytes: [0xd1, 0x80, 0x00])
        assertEqual(decoded, expected)
        guard let value = decoded, case .int = value else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodeNegativeInt32() {
        let expected = MessagePack(Int32.min)
        let decoded = try? MessagePack.decode(bytes: [0xd2, 0x80, 0x00, 0x00, 0x00])
        assertEqual(decoded, expected)
        guard let value = decoded, case .int = value else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodeNegativeInt64() {
        let expected = MessagePack(Int64.min)
        let decoded = try? MessagePack.decode(bytes: [0xd3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        assertEqual(decoded, expected)
        guard let value = decoded, case .int = value else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodeUInt8() {
        let expected = MessagePack(UInt8.max)
        let decoded = try? MessagePack.decode(bytes: [0xcc, 0xff])
        assertEqual(decoded, expected)
        guard let value = decoded, case .uint = value else {
            fail("decoded value is not type of .uint")
            return
        }
    }

    func testDecodeUInt16() {
        let expected = MessagePack(UInt16.max)
        let decoded = try? MessagePack.decode(bytes: [0xcd, 0xff, 0xff])
        assertEqual(decoded, expected)
        guard let value = decoded, case .uint = value else {
            fail("decoded value is not type of .uint")
            return
        }
    }

    func testDecodeUInt32() {
        let expected = MessagePack(UInt32.max)
        let decoded = try? MessagePack.decode(bytes: [0xce, 0xff, 0xff, 0xff, 0xff])
        assertEqual(decoded, expected)
        guard let value = decoded, case .uint = value else {
            fail("decoded value is not type of .uint")
            return
        }
    }

    func testDecodeUInt64() {
        let expected = MessagePack(UInt64.max)
        let decoded = try? MessagePack.decode(bytes: [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
        assertEqual(decoded, expected)
        guard let value = decoded, case .uint = value else {
            fail("decoded value is not type of .uint")
            return
        }
    }
}
