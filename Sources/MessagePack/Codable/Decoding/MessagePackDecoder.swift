public final class MessagePackDecoder: Decoder {
    public var codingPath: [CodingKey] {
        return []
    }
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    let object: MessagePack

    init(_ object: MessagePack) {
        self.object = object
    }

    public func container<Key>(
        keyedBy type: Key.Type
    ) throws -> KeyedDecodingContainer<Key> {
        guard case .map(let dictionary) = object else {
            throw DecodingError.typeMismatch([MessagePack : MessagePack].self, nil)
        }
        let container = MessagePackKeyedDecodingContainer<Key>(dictionary)
        return KeyedDecodingContainer(container)
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case .array(let array) = object else {
            throw DecodingError.typeMismatch([MessagePack].self, nil)
        }
        return MessagePackUnkeyedDecodingContainer(array)
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return MessagePackSingleValueDecodingContainer(object)
    }
}
