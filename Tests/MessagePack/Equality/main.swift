import Test
import MessagePack

test.case("NilEquality") {
    expect(MessagePack.nil == MessagePack.nil)
    expect(MessagePack.nil != MessagePack.bool(false))
    expect(MessagePack.nil != MessagePack.float(1.618))
    expect(MessagePack.nil != MessagePack.double(1.618))
    expect(MessagePack.nil != MessagePack.int(1))
    expect(MessagePack.nil != MessagePack.uint(1))
}

test.case("IntEquality") {
    expect(MessagePack.int(1) == MessagePack.int(1))
    expect(MessagePack.int(1) != MessagePack.uint(1))
}

test.case("UIntEquality") {
    expect(MessagePack.uint(1) == MessagePack.uint(1))
    expect(MessagePack.uint(1) != MessagePack.int(1))
}

test.case("BoolEquality") {
    expect(MessagePack.bool(true) == MessagePack.bool(true))
    expect(MessagePack.bool(false) == MessagePack.bool(false))
    expect(MessagePack.bool(true) != MessagePack.bool(false))
    expect(MessagePack.bool(false) != MessagePack.bool(true))
}

test.case("FloatEquality") {
    expect(MessagePack.float(1.618) == MessagePack.float(1.618))
    expect(MessagePack.double(1.618) == MessagePack.double(1.618))
    expect(MessagePack.float(1.618) != MessagePack.double(1.618))
    expect(MessagePack.double(1.618) != MessagePack.float(1.618))
}

test.case("StringEquality") {
    let helloWorld = "Hello, world!"
    expect(MessagePack.string(helloWorld) == MessagePack.string(helloWorld))
}

test.case("ArrayEquality") {
    expect(MessagePack.array([0, 1, 2, 3]) == MessagePack.array([0, 1, 2, 3]))
}

test.case("MapEquality") {
    let array: [MessagePack: MessagePack] = ["zero": 0, "one": 1, "two": 2, "three": 3]
    expect(MessagePack.map(array) == MessagePack.map(array))
}

test.case("BinaryEquality") {
    let array: [UInt8] = [0x00, 0x01, 0x02, 0x03]
    expect(MessagePack.binary(array) == MessagePack.binary(array))
}

test.case("ExtendedEquality") {
    let extended = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03, 0xff])
    expect(MessagePack.extended(extended) == MessagePack.extended(extended))
}

test.run()
