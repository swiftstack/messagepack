import Test
@testable import MessagePack

test.case("UnkeyedContainer") {
    let encoded: MessagePack = .array([
        MessagePack.`nil`,
        MessagePack.int(-1),
        MessagePack.int(-2),
        MessagePack.int(-3),
        MessagePack.int(-4),
        MessagePack.int(-5),
        MessagePack.uint(1),
        MessagePack.uint(2),
        MessagePack.uint(3),
        MessagePack.uint(4),
        MessagePack.uint(5),
        MessagePack.bool(true),
        MessagePack.float(3.14),
        MessagePack.double(3.14),
        MessagePack.string("hello"),
        MessagePack.array([.int(1), .int(2)]),
        MessagePack.map([.int(1): .int(2)])
    ])

    let decoder = Decoder(encoded)
    var container = try decoder.unkeyedContainer()

    expect(try container.decodeNil() == true)
    expect(try container.decode(Int.self) == -1)
    expect(try container.decode(Int8.self) == -2)
    expect(try container.decode(Int16.self) == -3)
    expect(try container.decode(Int32.self) == -4)
    expect(try container.decode(Int64.self) == -5)
    expect(try container.decode(UInt.self) == 1)
    expect(try container.decode(UInt8.self) == 2)
    expect(try container.decode(UInt16.self) == 3)
    expect(try container.decode(UInt32.self) == 4)
    expect(try container.decode(UInt64.self) == 5)
    expect(try container.decode(Bool.self) == true)
    expect(try container.decode(Float.self) == 3.14)
    expect(try container.decode(Double.self) == 3.14)
    expect(try container.decode(String.self) == "hello")
    expect(try container.decode([Int].self) == [1, 2])
    expect(try container.decode([Int : Int].self) == [1 : 2])
}

test.case("NestedKeyedContainer") {
    let encoded: MessagePack = .array([
        .int(1),
        .map([
            .string("nested"): .int(2)
        ]),
        .int(3)
    ])

    enum One: CodingKey {
        case nested
    }

    let decoder = Decoder(encoded)
    var container = try decoder.unkeyedContainer()
    expect(try container.decode(Int.self) == 1)

    let nested = try container.nestedContainer(keyedBy: One.self)
    expect(try nested.decode(Int.self, forKey: .nested) == 2)

    expect(try container.decode(Int.self) == 3)
}

test.case("NestedUnkeyedContainer") {
    let encoded: MessagePack = .array([
        .int(1),
        .array([.int(2)]),
        .int(3)
    ])

    let decoder = Decoder(encoded)
    var container = try decoder.unkeyedContainer()
    expect(try container.decode(Int.self) == 1)

    var nested = try container.nestedUnkeyedContainer()
    expect(try nested.decode(Int.self) == 2)

    expect(try container.decode(Int.self) == 3)
}

test.run()
