import XCTest
import MessagePack

class NilTests: XCTestCase {
    func testEncodeNil() {
        let expected: [UInt8] = [0xc0]
        let encoded = MessagePack.encode(.nil)
        XCTAssertEqual(encoded, expected)
    }

    func testDecodeNil() {
        let expected = MessagePack.nil
        let decoded = try? MessagePack.decode(bytes: [0xc0])
        XCTAssertEqual(decoded, expected)
    }
}
