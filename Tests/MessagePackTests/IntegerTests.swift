import Test
import MessagePack

class IntegerTests: TestCase {
    func testEncodeNegativeIntToFixInt() throws {
        let expected: [UInt8] = [0xff]
        let encoded = try MessagePack.encode(.int(-1))
        expect(encoded == expected)
    }

    func testEncodePositiveIntToFixInt() throws {
        let expected: [UInt8] = [0x01]
        let encoded = try MessagePack.encode(.uint(1))
        expect(encoded == expected)
    }

    func testEncodeInt() throws {
        let expected: [UInt8] = MemoryLayout<Int>.size == MemoryLayout<Int64>.size ?
            [0xd3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]:
            [0xd2, 0x80, 0x00, 0x00, 0x00]

        let encoded = try MessagePack.encode(.int(Int.min))
        expect(encoded == expected)
    }

    func testEncodeUInt() throws {
        let expected: [UInt8] = MemoryLayout<Int>.size == MemoryLayout<Int64>.size ?
            [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]:
            [0xce, 0xff, 0xff, 0xff, 0xff]

        let encoded = try MessagePack.encode(.uint(UInt.max))
        expect(encoded == expected)
    }

    func testDecodeNegativeFixInt() throws {
        let expected = MessagePack.int(-1)
        let decoded = try MessagePack.decode(bytes: [0xff])
        expect(decoded == expected)
        guard case .int = decoded else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodePositiveFixInt() throws {
        let expected = MessagePack.uint(1)
        let decoded = try MessagePack.decode(bytes: [0x01])
        expect(decoded == expected)
        guard case .uint = decoded else {
            fail("decoded value is not type of .uint")
            return
        }
    }

    func testDecodeNegativeInt8() throws {
        let expected = MessagePack(Int8.min)
        let decoded = try MessagePack.decode(bytes: [0xd0, 0x80])
        expect(decoded == expected)
        guard case .int = decoded else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodeNegativeInt16() throws {
        let expected = MessagePack(Int16.min)
        let decoded = try MessagePack.decode(bytes: [0xd1, 0x80, 0x00])
        expect(decoded == expected)
        guard case .int = decoded else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodeNegativeInt32() throws {
        let expected = MessagePack(Int32.min)
        let decoded = try MessagePack.decode(
            bytes: [0xd2, 0x80, 0x00, 0x00, 0x00])
        expect(decoded == expected)
        guard case .int = decoded else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodeNegativeInt64() throws {
        let expected = MessagePack(Int64.min)
        let decoded = try MessagePack.decode(
            bytes: [0xd3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        expect(decoded == expected)
        guard case .int = decoded else {
            fail("decoded value is not type of .int")
            return
        }
    }

    func testDecodeUInt8() throws {
        let expected = MessagePack(UInt8.max)
        let decoded = try MessagePack.decode(bytes: [0xcc, 0xff])
        expect(decoded == expected)
        guard case .uint = decoded else {
            fail("decoded value is not type of .uint")
            return
        }
    }

    func testDecodeUInt16() throws {
        let expected = MessagePack(UInt16.max)
        let decoded = try MessagePack.decode(bytes: [0xcd, 0xff, 0xff])
        expect(decoded == expected)
        guard case .uint = decoded else {
            fail("decoded value is not type of .uint")
            return
        }
    }

    func testDecodeUInt32() throws {
        let expected = MessagePack(UInt32.max)
        let decoded = try MessagePack.decode(
            bytes: [0xce, 0xff, 0xff, 0xff, 0xff])
        expect(decoded == expected)
        guard case .uint = decoded else {
            fail("decoded value is not type of .uint")
            return
        }
    }

    func testDecodeUInt64() throws {
        let expected = MessagePack(UInt64.max)
        let decoded = try MessagePack.decode(
            bytes: [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
        expect(decoded == expected)
        guard case .uint = decoded else {
            fail("decoded value is not type of .uint")
            return
        }
    }
}
