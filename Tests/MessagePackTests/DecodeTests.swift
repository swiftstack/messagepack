import MessagePack

class DecodeAsTests: TestCase {
    func testBool() {
        let expected = true
        let encoded = MessagePack.encode(.bool(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(Bool.self)
        assertEqual(decoded, expected)
    }

    func testFloat() {
        let expected = Float(1.618)
        let encoded = MessagePack.encode(.float(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(Float.self)
        assertEqual(decoded, expected)
    }

    func testDouble() {
        let expected = Double(1.618)
        let encoded = MessagePack.encode(.double(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(Double.self)
        assertEqual(decoded, expected)
    }

    func testString() {
        let expected = "Hello, World!"
        let encoded = MessagePack.encode(.string(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(String.self)
        assertEqual(decoded, expected)
    }

    func testInt() {
        let expected = Int.min
        let encoded = MessagePack.encode(.int(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(Int.self)
        assertEqual(decoded, expected)
    }

    func testUInt() {
        let expected = UInt.max
        let encoded = MessagePack.encode(.uint(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(UInt.self)
        assertEqual(decoded, expected)
    }

    func testUIntToInt() {
        let expected: UInt = 1
        let encoded = MessagePack.encode(.uint(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(Int.self)
        assertEqual(UInt(decoded), expected)
    }

    func testUIntMaxToInt() {
        let expected = UInt.max
        let encoded = MessagePack.encode(.uint(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        assertThrowsError(try decoder.decode(Int.self))
    }

    func testBinary() {
        let expected: [UInt8] = [0x01, 0x02, 0x03]
        let encoded = MessagePack.encode(.binary(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode([UInt8].self)
        assertEqual(decoded, expected)
    }

    func testArray() {
        let expected: [MessagePack] = [.string("Hello"), .string("World")]
        let encoded = MessagePack.encode(.array(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode([MessagePack].self)
        assertEqual(decoded, expected)
    }

    func testMap() {
        typealias Map = [MessagePack : MessagePack]
        let expected: Map = [.string("Hello"): .string("World")]
        let encoded = MessagePack.encode(.map(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(Map.self)
        assertEqual(decoded, expected)
    }

    func testExtended() {
        let expected = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let encoded = MessagePack.encode(.extended(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(MessagePack.Extended.self)
        assertEqual(decoded, expected)
    }
}
