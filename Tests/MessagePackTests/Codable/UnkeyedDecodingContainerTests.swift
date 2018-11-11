import Test
@testable import MessagePack

class UnkeyedDecodingContainerTests: TestCase {
    func testUnkeyedContainer() {
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

        scope {
            let decoder = Decoder(encoded)
            var container = try decoder.unkeyedContainer()

            assertEqual(try container.decodeNil(), true)
            assertEqual(try container.decode(Int.self), -1)
            assertEqual(try container.decode(Int8.self), -2)
            assertEqual(try container.decode(Int16.self), -3)
            assertEqual(try container.decode(Int32.self), -4)
            assertEqual(try container.decode(Int64.self), -5)
            assertEqual(try container.decode(UInt.self), 1)
            assertEqual(try container.decode(UInt8.self), 2)
            assertEqual(try container.decode(UInt16.self), 3)
            assertEqual(try container.decode(UInt32.self), 4)
            assertEqual(try container.decode(UInt64.self), 5)
            assertEqual(try container.decode(Bool.self), true)
            assertEqual(try container.decode(Float.self), 3.14)
            assertEqual(try container.decode(Double.self), 3.14)
            assertEqual(try container.decode(String.self), "hello")
            assertEqual(try container.decode([Int].self), [1, 2])
            assertEqual(try container.decode([Int : Int].self), [1 : 2])
        }
    }

    func testNestedKeyedContainer() {
        let encoded: MessagePack = .array([
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

            let decoder = Decoder(encoded)
            var container = try decoder.unkeyedContainer()
            assertEqual(try container.decode(Int.self), 1)

            let nested = try container.nestedContainer(keyedBy: One.self)
            assertEqual(try nested.decode(Int.self, forKey: .nested), 2)

            assertEqual(try container.decode(Int.self), 3)
        }
    }

    func testNestedUnkeyedContainer() {
        let encoded: MessagePack = .array([
            .int(1),
            .array([.int(2)]),
            .int(3)
        ])

        scope {
            let decoder = Decoder(encoded)
            var container = try decoder.unkeyedContainer()
            assertEqual(try container.decode(Int.self), 1)

            var nested = try container.nestedUnkeyedContainer()
            assertEqual(try nested.decode(Int.self), 2)

            assertEqual(try container.decode(Int.self), 3)
        }
    }
}
