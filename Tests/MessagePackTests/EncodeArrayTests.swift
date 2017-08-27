import Test
import MessagePack

class EncodeArrayTests: TestCase {
    func testEncodeBoolArray() {
        let booleans: [Bool] = [true, false]
        let expected: [UInt8] = [0x92, 0xc3, 0xc2]

        var encoder = MessagePackEncoder()
        encoder.encode(array: booleans)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeUIntArray() {
        let bytes: [UInt] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeUInt8Array() {
        let bytes: [UInt8] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeUInt16Array() {
        let bytes: [UInt16] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeUInt32Array() {
        let bytes: [UInt32] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeUInt64Array() {
        let bytes: [UInt64] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeIntArray() {
        let bytes: [Int] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeInt8Array() {
        let bytes: [Int8] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeInt16Array() {
        let bytes: [Int16] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeInt32Array() {
        let bytes: [Int32] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }

    func testEncodeInt64Array() {
        let bytes: [Int64] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var encoder = MessagePackEncoder()
        encoder.encode(array: bytes)

        assertEqual(encoder.bytes, expected)
    }
}
