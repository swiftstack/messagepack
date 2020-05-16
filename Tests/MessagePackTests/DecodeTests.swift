import Test
import Stream
import MessagePack

class DecodeTests: TestCase {
    func testBool() throws {
        let expected = true
        let encoded = try MessagePack.encode(.bool(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(Bool.self)
        expect(decoded == expected)
    }

    func testFloat() throws {
        let expected = Float(1.618)
        let encoded = try MessagePack.encode(.float(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(Float.self)
        expect(decoded == expected)
    }

    func testDouble() throws {
        let expected = Double(1.618)
        let encoded = try MessagePack.encode(.double(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(Double.self)
        expect(decoded == expected)
    }

    func testString() throws {
        let expected = "Hello, World!"
        let encoded = try MessagePack.encode(.string(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(String.self)
        expect(decoded == expected)
    }

    func testInt() throws {
        let expected = Int.min
        let encoded = try MessagePack.encode(.int(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(Int.self)
        expect(decoded == expected)
    }

    func testUInt() throws {
        let expected = UInt.max
        let encoded = try MessagePack.encode(.uint(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(UInt.self)
        expect(decoded == expected)
    }

    func testUIntToInt() throws {
        let expected: UInt = 1
        let encoded = try MessagePack.encode(.uint(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(Int.self)
        expect(UInt(decoded) == expected)
    }

    func testUIntMaxToInt() throws {
        let expected = UInt.max
        let encoded = try MessagePack.encode(.uint(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        expect(throws: MessagePack.Error.invalidData) {
            try reader.decode(Int.self)
        }
    }

    func testBinary() throws {
        let expected: [UInt8] = [0x01, 0x02, 0x03]
        let encoded = try MessagePack.encode(.binary(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode([UInt8].self)
        expect(decoded == expected)
    }

    func testArray() throws {
        let expected: [MessagePack] = [.string("Hello"), .string("World")]
        let encoded = try MessagePack.encode(.array(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode([MessagePack].self)
        expect(decoded == expected)
    }

    func testMap() throws {
        typealias Map = [MessagePack : MessagePack]
        let expected: Map = [.string("Hello"): .string("World")]
        let encoded = try MessagePack.encode(.map(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(Map.self)
        expect(decoded == expected)
    }

    func testExtended() throws {
        let expected = MessagePack.Extended(
            type: 1, data: [0x01, 0x02, 0x03])
        let encoded = try MessagePack.encode(.extended(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try reader.decode(MessagePack.Extended.self)
        expect(decoded == expected)
    }
}
