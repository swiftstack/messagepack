import Test
@testable import MessagePack

test("KeyedContainer") {
    let encoded: MessagePack = .map([
        .string("nil"): .nil,
        .string("int"): .int(-1),
        .string("int8"): .int(-2),
        .string("int16"): .int(-3),
        .string("int32"): .int(-4),
        .string("int64"): .int(-5),
        .string("uint"): .uint(1),
        .string("uint8"): .uint(2),
        .string("uint16"): .uint(3),
        .string("uint32"): .uint(4),
        .string("uint64"): .uint(5),
        .int(42): .bool(true),
        .string("float"): .float(3.14),
        .string("double"): .double(3.14),
        .string("string"): .string("hi"),
        .string("array"): .array([.int(1), .int(2)]),
        .string("map"): .map([.int(1): .int(2)]),
    ])

    enum Keys: CodingKey {
        case `nil`
        case bool
        case int, int8, int16, int32, int64
        case uint, uint8, uint16, uint32, uint64
        case float, double
        case string
        case array
        case map
        case extended

        var intValue: Int? {
            guard case .bool = self else {
                return nil
            }
            return 42
        }
    }

    let decoder = Decoder(encoded)
    let container = try decoder.container(keyedBy: Keys.self)

    expect(try container.decodeNil(forKey: .nil) == true)
    expect(try container.decode(Int.self, forKey: .int) == -1)
    expect(try container.decode(Int8.self, forKey: .int8) == -2)
    expect(try container.decode(Int16.self, forKey: .int16) == -3)
    expect(try container.decode(Int32.self, forKey: .int32) == -4)
    expect(try container.decode(Int64.self, forKey: .int64) == -5)
    expect(try container.decode(UInt.self, forKey: .uint) == 1)
    expect(try container.decode(UInt8.self, forKey: .uint8) == 2)
    expect(try container.decode(UInt16.self, forKey: .uint16) == 3)
    expect(try container.decode(UInt32.self, forKey: .uint32) == 4)
    expect(try container.decode(UInt64.self, forKey: .uint64) == 5)
    expect(try container.decode(Bool.self, forKey: .bool) == true)
    expect(try container.decode(Float.self, forKey: .float) == 3.14)
    expect(try container.decode(Double.self, forKey: .double) == 3.14)
    expect(try container.decode(String.self, forKey: .string) == "hi")
    expect(try container.decode([Int].self, forKey: .array) == [1, 2])
    expect(try container.decode([Int:Int].self, forKey: .map) == [1:2])
}

test("NestedKeyedContainer") {
    let encoded: MessagePack = .map([
        .string("one"): .int(1),
        .string("nested"): .map([
            .string("two"): .int(2)
        ]),
        .string("three"): .int(3)
    ])

    enum One: CodingKey {
        case one
        case nested
        case three
    }

    enum Two: CodingKey {
        case two
    }

    let decoder = Decoder(encoded)
    let container = try decoder.container(keyedBy: One.self)
    expect(try container.decode(Int.self, forKey: .one) == 1)

    let nested = try container.nestedContainer(
        keyedBy: Two.self, forKey: .nested)
    expect(try nested.decode(Int.self, forKey: .two) == 2)

    expect(try container.decode(Int.self, forKey: .three) == 3)
}

test("NestedUnkeyedContainer") {
    let encoded: MessagePack = .map([
        .string("one"): .int(1),
        .string("nested"): .array([.int(2)]),
        .string("three"): .int(3)
    ])

    enum One: CodingKey {
        case one
        case nested
        case three
    }

    enum Two: CodingKey {
        case two
    }

    let decoder = Decoder(encoded)
    let container = try decoder.container(keyedBy: One.self)
    expect(try container.decode(Int.self, forKey: .one) == 1)

    var nested = try container.nestedUnkeyedContainer(forKey: .nested)
    expect(try nested.decode(Int.self) == 2)

    expect(try container.decode(Int.self, forKey: .three) == 3)
}

await run()
