import Codable

typealias Encoder = MessagePack.Encoder

extension MessagePack {
    public final class Encoder: Swift.Encoder {
        public var codingPath: [CodingKey] { return [] }
        public var userInfo: [CodingUserInfoKey : Any] { return [:] }

        public init() {}

        enum Container {
            case raw(MessagePack)
            case keyed(TypeErasedContainer)
            case unkeyed(UnkeyedContainer)
            case singleValue(SingleValueContainer)
            case superEncoder(Encoder)

            var rawValue: MessagePack {
                switch self {
                case .raw(let value): return value
                case .keyed(let container): return container.value
                case .unkeyed(let container): return container.value
                case .singleValue(let container): return container.value
                case .superEncoder(let container): return container.value
                }
            }
        }

        private var container: Container?

        public var value: MessagePack {
            switch container {
            case .some(let container): return container.rawValue
            case .none: return .nil
            }
        }

        public func container<Key>(
            keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
        {
            let container: TypeErasedContainer
            switch self.container {
            case .some(let existing):
                guard case .keyed(let keyedContainer) = existing else {
                    return KeyedEncodingContainer(
                        KeyedEncodingError(.containerTypeMismatch(
                            requested: .keyed(by: type),
                            actual: existing)))
                }
                container = keyedContainer
            case .none:
                container = TypeErasedContainer()
                self.container = .keyed(container)
            }
            let keyedContainer = KeyedContainer<Key>(
                encoder: self, container: container)
            return KeyedEncodingContainer(keyedContainer)
        }

        public func unkeyedContainer() -> UnkeyedEncodingContainer {
            switch self.container {
            case .some(.unkeyed(let container)):
                return container
            case .some(let container):
                return EncodingError(.containerTypeMismatch(
                    requested: .unkeyed,
                    actual: container))
            default:
                let container = UnkeyedContainer(self)
                self.container = .unkeyed(container)
                return container
            }
        }

        public func singleValueContainer() -> SingleValueEncodingContainer {
            switch self.container {
            // FIXME: this is a hack for initial [Swift.Encodable]
            // implementation before conditional conforamce was introduced
            // TODO: investigate current behavior, change to .single (or not)
            // and remove SingleValueEncodingContainer from UnkeyedContainer
            case .some(.unkeyed(let container)):
                return container
            case .some(let container):
                return EncodingError(.containerTypeMismatch(
                    requested: .singleValue,
                    actual: container))
            default:
                let container = SingleValueContainer()
                self.container = .singleValue(container)
                return container
            }
        }
    }
}
