typealias Decoder = MessagePack.Decoder

extension MessagePack {
    public final class Decoder: Swift.Decoder {
        public var codingPath: [CodingKey] { return [] }
        public var userInfo: [CodingUserInfoKey : Any] { return [:] }

        private let value: MessagePack

        public init(_ value: MessagePack) {
            self.value = value
        }

        public func container<Key>(keyedBy type: Key.Type) throws
            -> KeyedDecodingContainer<Key>
        {
            guard case .map(let dictionary) = value else {
                throw Error.containerTypeMismatch(
                    requested: .keyed(by: type),
                    actual: value)
            }
            let container = KeyedContainer<Key>(dictionary)
            return KeyedDecodingContainer(container)
        }

        public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            guard case .array(let array) = value else {
                throw Error.containerTypeMismatch(
                    requested: .unkeyed,
                    actual: value)
            }
            return UnkeyedContainer(array)
        }

        public func singleValueContainer() throws
            -> SingleValueDecodingContainer
        {
            return SingleValueContainer(value)
        }
    }
}
