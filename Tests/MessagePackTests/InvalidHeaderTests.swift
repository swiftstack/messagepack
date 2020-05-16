import Test
import Stream
@testable import MessagePack

class InvalidHeaderTests: TestCase {
    func testStringHeader() {
        let header: [UInt8] = [0xff]
        var reader = MessagePackReader(InputByteStream(header))
        expect(throws: MessagePack.Error.invalidData) {
            try reader.readStringHeader(code: reader.readCode())
        }
    }

    func testArrayHeader() {
        let header: [UInt8] = [0xff]
        var reader = MessagePackReader(InputByteStream(header))
        expect(throws: MessagePack.Error.invalidData) {
            try reader.readArrayHeader(code: reader.readCode())
        }
    }

    func testMapHeader() {
        let header: [UInt8] = [0xff]
        var reader = MessagePackReader(InputByteStream(header))
        expect(throws: MessagePack.Error.invalidData) {
            try reader.readMapHeader(code: reader.readCode())
        }
    }

    func testBinaryHeader() {
        let header: [UInt8] = [0xff]
        var reader = MessagePackReader(InputByteStream(header))
        expect(throws: MessagePack.Error.invalidData) {
            try reader.readBinaryHeader(code: reader.readCode())
        }
    }

    func testExtendedHeader() {
        let header: [UInt8] = [0xff]
        var reader = MessagePackReader(InputByteStream(header))
        expect(throws: MessagePack.Error.invalidData) {
            try reader.readExtendedHeader(code: reader.readCode())
        }
    }
}
