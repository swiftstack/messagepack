import XCTest
import MessagePack

class NilTests: XCTestCase {
    func testSerializerNil() {
        let expected: [UInt8] = [0xc0]
        let packed = MessagePack.serialize(.nil)
        XCTAssertEqual(packed, expected)
    }

    func testDeserializerNil() {
        let expected = MessagePack.nil
        let unpacked = try? MessagePack.deserialize(bytes: [0xc0])
        XCTAssertEqual(unpacked, expected)
    }
}
