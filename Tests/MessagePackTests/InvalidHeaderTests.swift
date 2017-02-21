@testable import MessagePack

class InvalidHeaderTests: TestCase {
    func testStringHeader() {
        var decoder = Decoder(bytes: [0xff])
        assertThrowsError(try decoder.readStringHeader(code: decoder.readCode()))
    }

    func testArrayHeader() {
        var decoder = Decoder(bytes: [0xff])
        assertThrowsError(try decoder.readArrayHeader(code: decoder.readCode()))
    }

    func testMapHeader() {
        var decoder = Decoder(bytes: [0xff])
        assertThrowsError(try decoder.readMapHeader(code: decoder.readCode()))
    }

    func testBinaryHeader() {
        var decoder = Decoder(bytes: [0xff])
        assertThrowsError(try decoder.readBinaryHeader(code: decoder.readCode()))
    }

    func testExtendedHeader() {
        var decoder = Decoder(bytes: [0xff])
        assertThrowsError(try decoder.readExtendedHeader(code: decoder.readCode()))
    }
}
