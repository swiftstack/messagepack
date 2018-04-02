public final class MessagePackEncoder: Encoder, MessagePackContainer {
    public var codingPath: [CodingKey] {
        return []
    }
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    public init() {}

    enum ContainerType {
        case keyed(MessagePackContainer)
        case unkeyed(MessagePackContainer)
        case singleValue(MessagePackContainer)
    }

    var container: ContainerType?

    public var value: MessagePack {
        guard let container = container else {
            return .nil
        }
        switch container {
        case .keyed(let container): return container.value
        case .unkeyed(let container): return container.value
        case .singleValue(let container): return container.value
        }
    }

    public func container<Key>(
        keyedBy type: Key.Type
    ) -> KeyedEncodingContainer<Key> {
        let typeErasedContainer: TypeErasedMessagePackKeyedEncodingContainer
        if let container = self.container {
            guard case .keyed(let container) = container else {
                fatalError("super encoder must use the same container type")
            }
            typeErasedContainer = container as! TypeErasedMessagePackKeyedEncodingContainer
        } else {
            typeErasedContainer = TypeErasedMessagePackKeyedEncodingContainer()
            self.container = .keyed(typeErasedContainer)
        }
        let container = MessagePackKeyedEncodingContainer<Key>(
            encoder: self, container: typeErasedContainer)
        return KeyedEncodingContainer(container)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        if let container = self.container {
            guard case .unkeyed(let container) = container else {
                fatalError("super encoder must use the same container type")
            }
            return container as! UnkeyedEncodingContainer
        }
        let container = MessagePackUnkeyedEncodingContainer(self)
        self.container = .unkeyed(container)
        return container
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        if let container = self.container {
            guard case .unkeyed(let container) = container else {
                fatalError("single value container can be called through" +
                    "super encoder only from unkeyed container")
            }
            return container as! SingleValueEncodingContainer
        }
        let container = MessagePackSingleValueEncodingContainer()
        self.container = .singleValue(container)
        return container
    }
}
