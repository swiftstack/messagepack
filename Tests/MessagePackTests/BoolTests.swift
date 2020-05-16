import Test
import MessagePack

class BoolTests: TestCase {
    func testEncodeBoolFalse() throws {
        let expected: [UInt8] = [0xc2]
        let encoded = try MessagePack.encode(.bool(false))
        expect(encoded == expected)
    }

    func testDecodeBoolFalse() throws {
        let expected = MessagePack.bool(false)
        let decoded = try MessagePack.decode(bytes: [0xc2])
        expect(decoded == expected)
    }

    func testEncodeBoolTrue() throws {
        let expected: [UInt8] = [0xc3]
        let encoded = try MessagePack.encode(.bool(true))
        expect(encoded == expected)
    }

    func testDecodeBoolTrue() throws {
        let expected = MessagePack.bool(true)
        let decoded = try MessagePack.decode(bytes: [0xc3])
        expect(decoded == expected)
    }
}
