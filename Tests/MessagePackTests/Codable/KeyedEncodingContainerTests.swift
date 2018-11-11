import Test
@testable import MessagePack

class KeyedEncodingContainerTests: TestCase {
    func testKeyedContainer() {
        let expected: MessagePack = .map([
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
            .string("string"): .string("hello"),
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

        scope {
            let encoder = Encoder()
            var container = encoder.container(keyedBy: Keys.self)

            try container.encodeNil(forKey: .nil)
            try container.encode(Int(-1), forKey: .int)
            try container.encode(Int8(-2), forKey: .int8)
            try container.encode(Int16(-3), forKey: .int16)
            try container.encode(Int32(-4), forKey: .int32)
            try container.encode(Int64(-5), forKey: .int64)
            try container.encode(UInt(1), forKey: .uint)
            try container.encode(UInt8(2), forKey: .uint8)
            try container.encode(UInt16(3), forKey: .uint16)
            try container.encode(UInt32(4), forKey: .uint32)
            try container.encode(UInt64(5), forKey: .uint64)
            try container.encode(true, forKey: .bool)
            try container.encode(Float(3.14), forKey: .float)
            try container.encode(Double(3.14), forKey: .double)
            try container.encode("hello", forKey: .string)
            try container.encode([1, 2], forKey: .array)
            try container.encode([1 : 2], forKey: .map)

            assertEqual(encoder.value, expected)
        }
    }

    func testNestedKeyedContainer() {
        let expected: MessagePack = .map([
            .string("one"): .int(1),
            .string("nested"): .map([
                .string("two"): .int(2)
            ]),
            .string("three"): .int(3)
        ])

        scope {
            enum One: CodingKey {
                case one
                case nested
                case three
            }

            enum Two: CodingKey {
                case two
            }

            let encoder = Encoder()
            var container = encoder.container(keyedBy: One.self)
            try container.encode(1, forKey: .one)

            var nested = container.nestedContainer(
                keyedBy: Two.self, forKey: .nested)
            try nested.encode(2, forKey: .two)

            try container.encode(3, forKey: .three)

            assertEqual(encoder.value, expected)
        }
    }

    func testNestedUnkeyedContainer() {
        let expected: MessagePack = .map([
            .string("one"): .int(1),
            .string("nested"): .array([.int(2)]),
            .string("three"): .int(3)
        ])

        scope {
            enum One: CodingKey {
                case one
                case nested
                case three
            }

            enum Two: CodingKey {
                case two
            }

            let encoder = Encoder()
            var container = encoder.container(keyedBy: One.self)
            try container.encode(1, forKey: .one)

            var nested = container.nestedUnkeyedContainer(forKey: .nested)
            try nested.encode(2)

            try container.encode(3, forKey: .three)

            assertEqual(encoder.value, expected)
        }
    }
}
