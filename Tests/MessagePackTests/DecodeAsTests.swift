import MessagePack

class DecodeAsTests: TestCase {
    func testBool() {
        let expected = true
        let encoded = try! MessagePack.encode(.bool(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: Bool.self)
        assertEqual(decoded, expected)
    }

    func testFloat() {
        let expected = Float(1.618)
        let encoded = try! MessagePack.encode(.float(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: Float.self)
        assertEqual(decoded, expected)
    }

    func testDouble() {
        let expected = Double(1.618)
        let encoded = try! MessagePack.encode(.double(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: Double.self)
        assertEqual(decoded, expected)
    }

    func testString() {
        let expected = "Hello, World!"
        let encoded = try! MessagePack.encode(.string(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: String.self)
        assertEqual(decoded, expected)
    }

    func testInt() {
        let expected = Int.min
        let encoded = try! MessagePack.encode(.int(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: Int.self)
        assertEqual(decoded, expected)
    }

    func testUInt() {
        let expected = UInt.max
        let encoded = try! MessagePack.encode(.uint(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: UInt.self)
        assertEqual(decoded, expected)
    }

    func testUIntToInt() {
        let expected: UInt = 1
        let encoded = try! MessagePack.encode(.uint(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: Int.self)
        assertEqual(UInt(decoded), expected)
    }

    func testUIntMaxToInt() {
        let expected = UInt.max
        let encoded = try! MessagePack.encode(.uint(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        assertThrowsError(try decoder.decode(as: Int.self))
    }

    func testBinary() {
        let expected: [UInt8] = [0x01, 0x02, 0x03]
        let encoded = try! MessagePack.encode(.binary(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: [UInt8].self)
        assertEqual(decoded, expected)
    }

    func testArray() {
        let expected: [MessagePack] = [.string("Hello"), .string("World")]
        let encoded = try! MessagePack.encode(.array(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: [MessagePack].self)
        assertEqual(decoded, expected)
    }

    func testMap() {
        typealias Map = [MessagePack : MessagePack]
        let expected: Map = [.string("Hello"): .string("World")]
        let encoded = try! MessagePack.encode(.map(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: Map.self)
        assertEqual(decoded, expected)
    }

    func testExtended() {
        let expected = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
        let encoded = try! MessagePack.encode(.extended(expected))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        let decoded = try! decoder.decode(as: MessagePack.Extended.self)
        assertEqual(decoded, expected)
    }
}
