import Test
import MessagePack

class DescriptionTests: TestCase {
    func testNilDescription() {
        let exected = ".nil"
        let description = MessagePack.nil.description
        assertEqual(description, exected)
    }

    func testBoolDescription() {
        let expectedTrue = ".bool(true)"
        let expectedFalse = ".bool(false)"
        let descriptionTrue = MessagePack.bool(true).description
        let descriptionFalse = MessagePack.bool(false).description
        assertEqual(descriptionTrue, expectedTrue)
        assertEqual(descriptionFalse, expectedFalse)
    }

    func testFloatDescription() {
        let expected = ".float(1.618)"
        let description = MessagePack.float(1.618).description
        assertEqual(description, expected)
    }

    func testDoubleDescription() {
        let expected = ".double(1.618)"
        let description = MessagePack.double(1.618).description
        assertEqual(description, expected)
    }

    func testStringDescription() {
        let expected = ".string(\"Hello, World!\")"
        let description = MessagePack.string("Hello, World!").description
        assertEqual(description, expected)
    }

    func testIntDescription() {
        let exected = ".int(-1)"
        let description = MessagePack.int(-1).description
        assertEqual(description, exected)
    }

    func testUIntDescription() {
        let exected = ".uint(1)"
        let description = MessagePack.uint(1).description
        assertEqual(description, exected)
    }

    func testArrayDescription() {
        let expected = ".array([.nil, .bool(true), .uint(1), " +
                        ".double(1.618), .string(\"Hello, World!\")])"
        let description = MessagePack.array(
            [nil, true, 1, 1.618, "Hello, World!"]).description
        assertEqual(description, expected)
    }

    func testMapDescription() {
        let expected = ".map([.string(\"Hello\"): .string(\"World\")])"
        let description = MessagePack.map(["Hello": "World"]).description
        assertEqual(description, expected)
    }

    func testBinaryDescription() {
        let expected = ".binary(010203ff)"
        let description = MessagePack.binary([0x01, 0x02, 0x03, 0xff]).description
        assertEqual(description, expected)
    }

    func testExtendedDescription() {
        let expected = ".extended({1, 010203ff})"
        let ext = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03, 0xff])
        let description = MessagePack.extended(ext).description
        assertEqual(description, expected)
    }
}
