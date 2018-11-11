extension Encoder {
    // shared between different keyed
    // containers, e.g. super encoder
    final class TypeErasedContainer {
        var values: [MessagePack : Container] = [:]

        var value: MessagePack {
            return .map(values.mapValues{ $0.rawValue })
        }
    }
}

extension Encoder {
    final class KeyedContainer<Key : CodingKey>: KeyedEncodingContainerProtocol
    {
        var codingPath: [CodingKey] { return [] }

        let encoder: Encoder
        let container: TypeErasedContainer

        init(encoder: Encoder, container: TypeErasedContainer) {
            self.encoder = encoder
            self.container = container
        }

        func encodeNil(forKey key: Key) throws {
            container.values[.init(key)] = .raw(.nil)
        }

        func encode(_ value: Bool, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.bool(value))
        }

        func encode(_ value: Int, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.int(value))
        }

        func encode(_ value: Int8, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.int(Int(value)))
        }

        func encode(_ value: Int16, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.int(Int(value)))
        }

        func encode(_ value: Int32, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.int(Int(value)))
        }

        func encode(_ value: Int64, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.int(Int(value)))
        }

        func encode(_ value: UInt, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.uint(UInt(value)))
        }

        func encode(_ value: UInt8, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.uint(UInt(value)))
        }

        func encode(_ value: UInt16, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.uint(UInt(value)))
        }

        func encode(_ value: UInt32, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.uint(UInt(value)))
        }

        func encode(_ value: UInt64, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.uint(UInt(value)))
        }

        func encode(_ value: Float, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.float(value))
        }

        func encode(_ value: Double, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.double(value))
        }

        func encode(_ value: String, forKey key: Key) throws {
            container.values[.init(key)] = .raw(.string(value))
        }

        func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
            let encoder = Encoder()
            try value.encode(to: encoder)
            container.values[.init(key)] = .raw(encoder.value)
        }

        func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type,
            forKey key: Key) -> KeyedEncodingContainer<NestedKey>
        {
            let container = TypeErasedContainer()
            let keyedContainer = KeyedContainer<NestedKey>(
                encoder: encoder,
                container: container)
            self.container.values[.init(key)] = .keyed(container)
            return KeyedEncodingContainer(keyedContainer)
        }

        func nestedUnkeyedContainer(
            forKey key: Key) -> UnkeyedEncodingContainer
        {
            let container = UnkeyedContainer(encoder)
            self.container.values[.init(key)] = .unkeyed(container)
            return container
        }

        func superEncoder() -> Swift.Encoder {
            return encoder
        }

        func superEncoder(forKey key: Key) -> Swift.Encoder {
            // TODO: test
            let encoder = Encoder()
            container.values[.init(key)] = .superEncoder(encoder)
            return encoder
        }
    }
}
