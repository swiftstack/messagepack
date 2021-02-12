import Test
import MessagePack

test.case("NilDescription") {
    let exected = ".nil"
    let description = MessagePack.nil.description
    expect(description == exected)
}

test.case("BoolDescription") {
    let expectedTrue = ".bool(true)"
    let expectedFalse = ".bool(false)"
    let descriptionTrue = MessagePack.bool(true).description
    let descriptionFalse = MessagePack.bool(false).description
    expect(descriptionTrue == expectedTrue)
    expect(descriptionFalse == expectedFalse)
}

test.case("FloatDescription") {
    let expected = ".float(1.618)"
    let description = MessagePack.float(1.618).description
    expect(description == expected)
}

test.case("DoubleDescription") {
    let expected = ".double(1.618)"
    let description = MessagePack.double(1.618).description
    expect(description == expected)
}

test.case("StringDescription") {
    let expected = ".string(\"Hello, World!\")"
    let description = MessagePack.string("Hello, World!").description
    expect(description == expected)
}

test.case("IntDescription") {
    let exected = ".int(-1)"
    let description = MessagePack.int(-1).description
    expect(description == exected)
}

test.case("UIntDescription") {
    let exected = ".uint(1)"
    let description = MessagePack.uint(1).description
    expect(description == exected)
}

test.case("ArrayDescription") {
    let expected =
        ".array([.nil, .bool(true), .uint(1), " +
        ".double(1.618), .string(\"Hello, World!\")])"
    let description = MessagePack.array(
        [nil, true, 1, 1.618, "Hello, World!"]).description
    expect(description == expected)
}

test.case("MapDescription") {
    let expected = ".map([.string(\"Hello\"): .string(\"World\")])"
    let description = MessagePack.map(["Hello": "World"]).description
    expect(description == expected)
}

test.case("BinaryDescription") {
    let expected = ".binary(010203ff)"
    let description = MessagePack.binary([0x01, 0x02, 0x03, 0xff]).description
    expect(description == expected)
}

test.case("ExtendedDescription") {
    let expected = ".extended({1, 010203ff})"
    let ext = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03, 0xff])
    let description = MessagePack.extended(ext).description
    expect(description == expected)
}
test.run()
