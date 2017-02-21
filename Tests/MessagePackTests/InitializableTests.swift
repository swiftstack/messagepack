import XCTest
import MessagePack

class InitializableTests: XCTestCase {
    func testBool() {
        let trueValue = Bool(MessagePack.bool(true))
        let falseValue = Bool(MessagePack.bool(false))
        XCTAssertEqual(trueValue, true)
        XCTAssertEqual(falseValue, false)
    }

    func testFloat() {
        let expected = Float(1.618)
        let value = Float(MessagePack.float(1.618))
        XCTAssertEqual(value, expected)
    }

    func testDouble() {
        let expected = 1.618
        let value = Double(MessagePack.double(1.618))
        XCTAssertEqual(value, expected)
    }

    func testString() {
        let expected = "Hello, World!"
        let value = String(MessagePack.string("Hello, World!"))
        XCTAssertEqual(value, expected)
    }

    func testInt() {
        let expected = Int.min
        let value = Int(MessagePack.int(Int.min))
        XCTAssertEqual(value, expected)
    }

    func testUInt() {
        let expected = UInt.max
        let value = UInt(MessagePack.uint(UInt.max))
        XCTAssertEqual(value, expected)
    }

    func testConversions() {
        let utos = Int(MessagePack.uint(1))
        let stou = UInt(MessagePack.int(1))
        XCTAssertNotNil(utos)
        XCTAssertNotNil(stou)
    }

    func testConversionsOverflow() {
        let utos = Int(MessagePack.uint(UInt.max))
        let stou = UInt(MessagePack.int(Int.min))
        XCTAssertNil(utos)
        XCTAssertNil(stou)
    }

    func testArray() {
        let expected: [MessagePack] = [MessagePack(1), MessagePack(2.0), MessagePack("three")]
        let encoded = MessagePack.array(expected)
        let array = [MessagePack](encoded)
        XCTAssertNotNil(array)
        if array != nil {
            XCTAssertEqual(array!, expected)
        }
    }

    func testMap() {
        let expected: [MessagePack : MessagePack] = [1:2, 3:4]
        let encoded = MessagePack.map(expected)
        let map = [MessagePack : MessagePack](encoded)
        XCTAssertNotNil(map)
        if map != nil {
            XCTAssertEqual(map!, expected)
        }
    }

    func testBinary() {
        let expected: [UInt8] = [1,2,3]
        let encoded = MessagePack.binary(expected)
        let bytes = [UInt8](encoded)
        XCTAssertNotNil(bytes)
        if bytes != nil {
            XCTAssertEqual(bytes!, expected)
        }
    }
}
