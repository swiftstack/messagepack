import Test
import MessagePack

class BoolTests: TestCase {
    func testEncodeBoolFalse() {
        let expected: [UInt8] = [0xc2]
        let encoded = try? MessagePack.encode(.bool(false))
        assertEqual(encoded ?? [], expected)
    }

    func testDecodeBoolFalse() {
        let expected = MessagePack.bool(false)
        let decoded = try? MessagePack.decode(bytes: [0xc2])
        assertEqual(decoded, expected)
    }

    func testEncodeBoolTrue() {
        let expected: [UInt8] = [0xc3]
        let encoded = try? MessagePack.encode(.bool(true))
        assertEqual(encoded ?? [], expected)
    }

    func testDecodeBoolTrue() {
        let expected = MessagePack.bool(true)
        let decoded = try? MessagePack.decode(bytes: [0xc3])
        assertEqual(decoded, expected)
    }
}
