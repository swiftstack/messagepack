import Test
@testable import MessagePack

class InvalidHeaderTests: TestCase {
    func testStringHeader() {
        let header: [UInt8] = [0xff]
        var decoder = UnsafeRawMessagePackDecoder(bytes: header, count: header.count)
        assertThrowsError(try decoder.readStringHeader(code: decoder.readCode()))
    }

    func testArrayHeader() {
        let header: [UInt8] = [0xff]
        var decoder = UnsafeRawMessagePackDecoder(bytes: header, count: header.count)
        assertThrowsError(try decoder.readArrayHeader(code: decoder.readCode()))
    }

    func testMapHeader() {
        let header: [UInt8] = [0xff]
        var decoder = UnsafeRawMessagePackDecoder(bytes: header, count: header.count)
        assertThrowsError(try decoder.readMapHeader(code: decoder.readCode()))
    }

    func testBinaryHeader() {
        let header: [UInt8] = [0xff]
        var decoder = UnsafeRawMessagePackDecoder(bytes: header, count: header.count)
        assertThrowsError(try decoder.readBinaryHeader(code: decoder.readCode()))
    }

    func testExtendedHeader() {
        let header: [UInt8] = [0xff]
        var decoder = UnsafeRawMessagePackDecoder(bytes: header, count: header.count)
        assertThrowsError(try decoder.readExtendedHeader(code: decoder.readCode()))
    }
}
