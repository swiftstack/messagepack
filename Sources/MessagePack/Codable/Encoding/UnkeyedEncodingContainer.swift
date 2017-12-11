extension Array where Element == MessagePackContainerType {
    mutating func append(_ newElement: MessagePack) {
        self.append(.value(newElement))
    }

    mutating func append(_ newElement: MessagePackContainer) {
        self.append(.container(newElement))
    }
}

final class MessagePackUnkeyedEncodingContainer
: UnkeyedEncodingContainer, SingleValueEncodingContainer, MessagePackContainer {
    var codingPath: [CodingKey] {
        return []
    }

    let encoder: _MessagePackEncoder

    var values: [MessagePackContainerType]

    var value: MessagePack {
        var values = [MessagePack]()
        for value in self.values {
            switch value {
            case .value(let value): values.append(value)
            case .container(let container): values.append(container.value)
            }
        }
        return .array(values)
    }

    var count: Int {
        return values.count
    }

    init(_ encoder: _MessagePackEncoder) {
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

    func encode<T>(_ value: T) throws where T : Encodable {
        let encoder = _MessagePackEncoder()
        try value.encode(to: encoder)
        values.append(encoder.value)
    }

    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        let typeErasedContainer = TypeErasedMessagePackKeyedEncodingContainer()
        let container = MessagePackKeyedEncodingContainer<NestedKey>(
            encoder: encoder, container: typeErasedContainer)
        values.append(.container(typeErasedContainer))
        return KeyedEncodingContainer(container)
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = MessagePackUnkeyedEncodingContainer(encoder)
        values.append(.container(container))
        return container
    }

    func superEncoder() -> Encoder {
        return encoder
    }
}
