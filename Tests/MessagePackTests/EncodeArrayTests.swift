import Test
import Stream
import MessagePack

class EncodeArrayTests: TestCase {
    func testEncodeBoolArray() throws {
        let booleans: [Bool] = [true, false]
        let expected: [UInt8] = [0x92, 0xc3, 0xc2]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: booleans)

        expect(stream.bytes == expected)
    }

    func testEncodeUIntArray() throws {
        let bytes: [UInt] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeUInt8Array() throws {
        let bytes: [UInt8] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeUInt16Array() throws {
        let bytes: [UInt16] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeUInt32Array() throws {
        let bytes: [UInt32] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeUInt64Array() throws {
        let bytes: [UInt64] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeIntArray() throws {
        let bytes: [Int] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeInt8Array() throws {
        let bytes: [Int8] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeInt16Array() throws {
        let bytes: [Int16] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeInt32Array() throws {
        let bytes: [Int32] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }

    func testEncodeInt64Array() throws {
        let bytes: [Int64] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(array: bytes)

        expect(stream.bytes == expected)
    }
}
