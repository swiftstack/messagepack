import XCTest
import MessagePack

class PackArrayTests: XCTestCase {

    func testSerializerPackBoolArray() {
        let booleans: [Bool] = [true, false]
        let expected: [UInt8] = [0x92, 0xc3, 0xc2]

        var serializer = MPSerializer()
        serializer.pack(array: booleans)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackUIntArray() {
        let bytes: [UInt] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackUInt8Array() {
        let bytes: [UInt8] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackUInt16Array() {
        let bytes: [UInt16] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackUInt32Array() {
        let bytes: [UInt32] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackUInt64Array() {
        let bytes: [UInt64] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackIntArray() {
        let bytes: [Int] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackInt8Array() {
        let bytes: [Int8] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackInt16Array() {
        let bytes: [Int16] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackInt32Array() {
        let bytes: [Int32] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }

    func testSerializerPackInt64Array() {
        let bytes: [Int64] = [0x01, 0x02, 0x03]
        let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

        var serializer = MPSerializer()
        serializer.pack(array: bytes)

        XCTAssertEqual(serializer.bytes, expected)
    }
}
