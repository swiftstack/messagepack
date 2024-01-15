import Test
import MessagePack

// TODO: test custom conformance instead

test("Array") {
    let packed = MessagePack.array([1, 2, 3])
    expect(packed.arrayValue?[0] == 1)
    expect(packed.arrayValue?[1] == 2)
    expect(packed.arrayValue?[2] == 3)
}

test("Dictionary") {
    let packed = MessagePack.map(["Hello": "World"])
    expect(packed.dictionaryValue?["Hello"] == "World")
}

test("Binary") {
    let packed = MessagePack.binary([0x01, 0x02, 0x03])
    expect(packed.binaryValue == [0x01, 0x02, 0x03])
}

test("Extended") {
    let original = MessagePack.Extended(type: 1, data: [0x01, 0x02, 0x03])
    let packed = MessagePack.extended(original)
    expect(packed.extendedValue?.type == 1)
    expect(packed.extendedValue?.data == [0x01, 0x02, 0x03])
}

test("ArrayOfInt") {
    let packed = MessagePack.array([1, 2, 3])
    expect(packed.arrayValue?[0] == 1)
    expect(packed.arrayValue?[1] == 2)
    expect(packed.arrayValue?[2] == 3)
}

test("ArrayOfString") {
    let packed = MessagePack.array(["one", "two", "three"])
    expect(packed.arrayValue?[0] == "one")
    expect(packed.arrayValue?[1] == "two")
    expect(packed.arrayValue?[2] == "three")
}

await run()
