import Test
import MessagePack

class DecodeTests: TestCase {
    func testBool() {
        let expected = true
        let encoded = try! MessagePack.encode(.bool(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(Bool.self)
        assertEqual(decoded, expected)
    }

    func testFloat() {
        let expected = Float(1.618)
        let encoded = try! MessagePack.encode(.float(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(Float.self)
        assertEqual(decoded, expected)
    }

    func testDouble() {
        let expected = Double(1.618)
        let encoded = try! MessagePack.encode(.double(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(Double.self)
        assertEqual(decoded, expected)
    }

    func testString() {
        let expected = "Hello, World!"
        let encoded = try! MessagePack.encode(.string(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(String.self)
        assertEqual(decoded, expected)
    }

    func testInt() {
        let expected = Int.min
        let encoded = try! MessagePack.encode(.int(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(Int.self)
        assertEqual(decoded, expected)
    }

    func testUInt() {
        let expected = UInt.max
        let encoded = try! MessagePack.encode(.uint(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(UInt.self)
        assertEqual(decoded, expected)
    }

    func testUIntToInt() {
        let expected: UInt = 1
        let encoded = try! MessagePack.encode(.uint(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(Int.self)
        assertEqual(UInt(decoded), expected)
    }

    func testUIntMaxToInt() {
        let expected = UInt.max
        let encoded = try! MessagePack.encode(.uint(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        assertThrowsError(try reader.decode(Int.self))
    }

    func testBinary() {
        let expected: [UInt8] = [0x01, 0x02, 0x03]
        let encoded = try! MessagePack.encode(.binary(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode([UInt8].self)
        assertEqual(decoded, expected)
    }

    func testArray() {
        let expected: [MessagePack] = [.string("Hello"), .string("World")]
        let encoded = try! MessagePack.encode(.array(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode([MessagePack].self)
        assertEqual(decoded, expected)
    }

    func testMap() {
        typealias Map = [MessagePack : MessagePack]
        let expected: Map = [.string("Hello"): .string("World")]
        let encoded = try! MessagePack.encode(.map(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(Map.self)
        assertEqual(decoded, expected)
    }

    func testExtended() {
        let expected = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let encoded = try! MessagePack.encode(.extended(expected))
        var reader = MessagePackReader(InputByteStream(encoded))
        let decoded = try! reader.decode(MessagePack.Extended.self)
        assertEqual(decoded, expected)
    }
}
