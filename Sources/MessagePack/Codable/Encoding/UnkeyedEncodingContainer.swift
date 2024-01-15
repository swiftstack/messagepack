extension Encoder {
    final class UnkeyedContainer:
        UnkeyedEncodingContainer,
        SingleValueEncodingContainer
    {
        var codingPath: [CodingKey] { return [] }

        let encoder: Encoder
        var values: [Container]

        var value: MessagePack {
            var values = [MessagePack]()
            for value in self.values {
                values.append(value.rawValue)
            }
            return .array(values)
        }

        var count: Int {
            return values.count
        }

        init(_ encoder: Encoder) {
            self.encoder = encoder
            self.values = []
        }

        func encodeNil() throws {
            values.append(.nil)
        }

        func encode(_ value: Int) throws {
            values.append(.int(value))
        }

        func encode(_ value: Int8) throws {
            values.append(.int(Int(value)))
        }

        func encode(_ value: Int16) throws {
            values.append(.int(Int(value)))
        }

        func encode(_ value: Int32) throws {
            values.append(.int(Int(value)))
        }

        func encode(_ value: Int64) throws {
            values.append(.int(Int(value)))
        }

        func encode(_ value: UInt) throws {
            values.append(.uint(value))
        }

        func encode(_ value: UInt8) throws {
            values.append(.uint(UInt(value)))
        }

        func encode(_ value: UInt16) throws {
            values.append(.uint(UInt(value)))
        }

        func encode(_ value: UInt32) throws {
            values.append(.uint(UInt(value)))
        }

        func encode(_ value: UInt64) throws {
            values.append(.uint(UInt(value)))
        }

        func encode(_ value: Float) throws {
            values.append(.float(value))
        }

        func encode(_ value: Double) throws {
            values.append(.double(value))
        }

        func encode(_ value: String) throws {
            values.append(.string(value))
        }

        func encode<T>(_ value: T) throws where T: Encodable {
            let encoder = Encoder()
            try value.encode(to: encoder)
            values.append(encoder.value)
        }

        func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type
        ) -> KeyedEncodingContainer<NestedKey> {
            let container = TypeErasedContainer()
            let keyedContainer = KeyedContainer<NestedKey>(
                encoder: encoder, container: container)
            values.append(.keyed(container))
            return KeyedEncodingContainer(keyedContainer)
        }

        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            let container = UnkeyedContainer(encoder)
            values.append(.unkeyed(container))
            return container
        }

        func superEncoder() -> Swift.Encoder {
            return encoder
        }
    }
}

extension Array where Element == MessagePack.Encoder.Container {
    mutating func append(_ rawValue: MessagePack) {
        self.append(.raw(rawValue))
    }

    mutating func append(_ container: Encoder.TypeErasedContainer) {
        self.append(.keyed(container))
    }

    mutating func append(_ container: Encoder.UnkeyedContainer) {
        self.append(.unkeyed(container))
    }

    mutating func append(_ container: Encoder.SingleValueContainer) {
        self.append(.singleValue(container))
    }
}
