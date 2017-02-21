import XCTest
import MessagePack

class BoolTests: XCTestCase {
    func testEncodeBoolFalse() {
        let expected: [UInt8] = [0xc2]
        let encoded = MessagePack.encode(.bool(false))
        XCTAssertEqual(encoded, expected)
    }

    func testDecodeBoolFalse() {
        let expected = MessagePack.bool(false)
        let decoded = try? MessagePack.decode(bytes: [0xc2])
        XCTAssertEqual(decoded, expected)
    }

    func testEncodeBoolTrue() {
        let expected: [UInt8] = [0xc3]
        let encoded = MessagePack.encode(.bool(true))
        XCTAssertEqual(encoded, expected)
    }

    func testDecodeBoolTrue() {
        let expected = MessagePack.bool(true)
        let decoded = try? MessagePack.decode(bytes: [0xc3])
        XCTAssertEqual(decoded, expected)
    }
}
