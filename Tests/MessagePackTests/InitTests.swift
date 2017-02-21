import XCTest
import MessagePack

class InitTests: XCTestCase {
    func testBytes() {
        let expected: MessagePack = [1,2,3]
        var decoder = Decoder(bytes: [0x93, 0x01, 0x02, 0x03])
        guard let decoded = try? decoder.decode() as MessagePack else {
            XCTFail("decode error")
            return
        }
        XCTAssertEqual(decoded, expected)
    }

    func testUnsafeBufferPointer() {
        let expected: MessagePack = [1,2,3]
        var decoder = Decoder(bytes: UnsafeBufferPointer(start: UnsafePointer([0x93, 0x01, 0x02, 0x03]), count: 4))
        guard let decoded = try? decoder.decode() as MessagePack else {
            XCTFail("decode error")
            return
        }
        XCTAssertEqual(decoded, expected)
    }

    func testUnsafePointer() {
        let expected: MessagePack = [1,2,3]
        var decoder = Decoder(bytes: UnsafePointer([0x93, 0x01, 0x02, 0x03]), count: 4)
        guard let decoded = try? decoder.decode() as MessagePack else {
            XCTFail("decode error")
            return
        }
        XCTAssertEqual(decoded, expected)
    }
}
