import MessagePack

class EqualityTests: TestCase {
    func testNilEquality() {
        assertEqual(MessagePack.nil, MessagePack.nil)
        assertNotEqual(MessagePack.nil,MessagePack.bool(false))
        assertNotEqual(MessagePack.nil, MessagePack.float(1.618))
        assertNotEqual(MessagePack.nil, MessagePack.double(1.618))
        assertNotEqual(MessagePack.nil, MessagePack.int(1))
        assertNotEqual(MessagePack.nil, MessagePack.uint(1))
    }

    func testIntEquality() {
        assertEqual(MessagePack.int(1), MessagePack.int(1))
        assertEqual(MessagePack.int(1), MessagePack.uint(1))
    }

    func testUIntEquality() {
        assertEqual(MessagePack.uint(1), MessagePack.int(1))
        assertEqual(MessagePack.uint(1), MessagePack.uint(1))
    }

    func testBoolEquality() {
        assertEqual(MessagePack.bool(true), MessagePack.bool(true))
        assertEqual(MessagePack.bool(false), MessagePack.bool(false))
        assertNotEqual(MessagePack.bool(true), MessagePack.bool(false))
        assertNotEqual(MessagePack.bool(false), MessagePack.bool(true))
    }

    func testFloatEquality() {
        assertEqual(MessagePack.float(1.618), MessagePack.float(1.618))
        assertEqual(MessagePack.double(1.618), MessagePack.double(1.618))
        assertNotEqual(MessagePack.float(1.618), MessagePack.double(1.618))
        assertNotEqual(MessagePack.double(1.618), MessagePack.float(1.618))
    }

    func testStringEquality() {
        let helloWorld = "Hello, world!"
        assertEqual(MessagePack.string(helloWorld), MessagePack.string(helloWorld))
    }

    func testArrayEquality() {
        assertEqual(MessagePack.array([0, 1, 2, 3]), MessagePack.array([0, 1, 2, 3]))
    }

    func testMapEquality() {
        let array: [MessagePack: MessagePack] = ["zero": 0, "one": 1, "two": 2, "three": 3]
        assertEqual(MessagePack.map(array), MessagePack.map(array))
    }

    func testBinaryEquality() {
        let array: [UInt8] = [0x00, 0x01, 0x02, 0x03]
        assertEqual(MessagePack.binary(array), MessagePack.binary(array))
    }

    func testExtendedEquality() {
        let extended = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03, 0xff])
        assertEqual(MessagePack.extended(extended), MessagePack.extended(extended))
    }
}
