import Test
@testable import MessagePack

class UnkeyedEncodingContainerTests: TestCase {
    func testUnkeyedContainer() {
        let expected: MessagePack = .array([
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

        scope {
            let encoder = Encoder()
            var container = encoder.unkeyedContainer()

            try container.encodeNil()
            try container.encode(Int(-1))
            try container.encode(Int8(-2))
            try container.encode(Int16(-3))
            try container.encode(Int32(-4))
            try container.encode(Int64(-5))
            try container.encode(UInt(1))
            try container.encode(UInt8(2))
            try container.encode(UInt16(3))
            try container.encode(UInt32(4))
            try container.encode(UInt64(5))
            try container.encode(true)
            try container.encode(Float(3.14))
            try container.encode(Double(3.14))
            try container.encode("hello")
            try container.encode([1, 2])
            try container.encode([1 : 2])

            assertEqual(encoder.value, expected)
        }
    }

    func testNestedKeyedContainer() {
        let expected: MessagePack = .array([
            .int(1),
            .map([
                .string("nested"): .int(2)
            ]),
            .int(3)
        ])

        scope {
            enum One: CodingKey {
                case nested
            }

            let encoder = Encoder()
            var container = encoder.unkeyedContainer()
            try container.encode(1)

            var nested = container.nestedContainer(keyedBy: One.self)
            try nested.encode(2, forKey: .nested)

            try container.encode(3)

            assertEqual(encoder.value, expected)
        }
    }

    func testNestedUnkeyedContainer() {
        let expected: MessagePack = .array([
            .int(1),
            .array([.int(2)]),
            .int(3)
        ])

        scope {
            let encoder = Encoder()
            var container = encoder.unkeyedContainer()
            try container.encode(1)

            var nested = container.nestedUnkeyedContainer()
            try nested.encode(2)

            try container.encode(3)

            assertEqual(encoder.value, expected)
        }
    }
}
