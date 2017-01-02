import XCTest
import MessagePack

class InitTests: XCTestCase {
    func testBytes() {
        let expected: MessagePack = [1,2,3]
        var unpacker = MPDeserializer(bytes: [0x93, 0x01, 0x02, 0x03])
        guard let unpacked = try? unpacker.unpack() as MessagePack else {
            XCTFail("unpack error")
            return
        }
        XCTAssertEqual(unpacked, expected)
    }

    func testUnsafeBufferPointer() {
        let expected: MessagePack = [1,2,3]
        var unpacker = MPDeserializer(bytes: UnsafeBufferPointer(start: UnsafePointer([0x93, 0x01, 0x02, 0x03]), count: 4))
        guard let unpacked = try? unpacker.unpack() as MessagePack else {
            XCTFail("unpack error")
            return
        }
        XCTAssertEqual(unpacked, expected)
    }

    func testUnsafePointer() {
        let expected: MessagePack = [1,2,3]
        var unpacker = MPDeserializer(bytes: UnsafePointer([0x93, 0x01, 0x02, 0x03]), count: 4)
        guard let unpacked = try? unpacker.unpack() as MessagePack else {
            XCTFail("unpack error")
            return
        }
        XCTAssertEqual(unpacked, expected)
    }
}
