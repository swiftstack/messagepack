import XCTest
@testable import MessagePack

class InvalidHeaderTests: XCTestCase {
    func testStringHeader() {
        var decoder = Decoder(bytes: [0xff])
        XCTAssertThrowsError(try decoder.readStringHeader(code: decoder.readCode()))
    }

    func testArrayHeader() {
        var decoder = Decoder(bytes: [0xff])
        XCTAssertThrowsError(try decoder.readArrayHeader(code: decoder.readCode()))
    }

    func testMapHeader() {
        var decoder = Decoder(bytes: [0xff])
        XCTAssertThrowsError(try decoder.readMapHeader(code: decoder.readCode()))
    }

    func testBinaryHeader() {
        var decoder = Decoder(bytes: [0xff])
        XCTAssertThrowsError(try decoder.readBinaryHeader(code: decoder.readCode()))
    }

    func testExtendedHeader() {
        var decoder = Decoder(bytes: [0xff])
        XCTAssertThrowsError(try decoder.readExtendedHeader(code: decoder.readCode()))
    }
}
