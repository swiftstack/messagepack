import XCTest
@testable import MessagePack

class InvalidCodeHeaderLengthTests: XCTestCase {

    func testStringHeader() {
        var deserializer = MPDeserializer(bytes: [0xff])
        XCTAssertThrowsError(try deserializer.readStringLength(code: deserializer.readCode()))
    }

    func testArrayHeader() {
        var deserializer = MPDeserializer(bytes: [0xff])
        XCTAssertThrowsError(try deserializer.readArrayLength(code: deserializer.readCode()))
    }

    func testMapHeader() {
        var deserializer = MPDeserializer(bytes: [0xff])
        XCTAssertThrowsError(try deserializer.readMapLength(code: deserializer.readCode()))
    }

    func testBinaryHeader() {
        var deserializer = MPDeserializer(bytes: [0xff])
        XCTAssertThrowsError(try deserializer.readBinaryLength(code: deserializer.readCode()))
    }

    func testExtendedHeader() {
        var deserializer = MPDeserializer(bytes: [0xff])
        XCTAssertThrowsError(try deserializer.readExtendedLength(code: deserializer.readCode()))
    }
}
