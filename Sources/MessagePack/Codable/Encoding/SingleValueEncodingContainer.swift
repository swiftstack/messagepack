class MessagePackSingleValueEncodingContainer
: SingleValueEncodingContainer, MessagePackContainer {
    var codingPath: [CodingKey] {
        return []
    }

    var value: MessagePack = .nil

    func encodeNil() throws {
        self.value = .nil
    }

    func encode(_ value: Bool) throws {
        self.value = .bool(value)
    }

    func encode(_ value: Int) throws {
        self.value = .int(value)
    }

    func encode(_ value: Int8) throws {
        self.value = .int(Int(value))
    }

    func encode(_ value: Int16) throws {
        self.value = .int(Int(value))
    }

    func encode(_ value: Int32) throws {
        self.value = .int(Int(value))
    }

    func encode(_ value: Int64) throws {
        self.value = .int(Int(value))
    }

    func encode(_ value: UInt) throws {
        self.value = .uint(value)
    }

    func encode(_ value: UInt8) throws {
        self.value = .uint(UInt(value))
    }

    func encode(_ value: UInt16) throws {
        self.value = .uint(UInt(value))
    }

    func encode(_ value: UInt32) throws {
        self.value = .uint(UInt(value))
    }

    func encode(_ value: UInt64) throws {
        self.value = .uint(UInt(value))
    }

    func encode(_ value: Float) throws {
        self.value = .float(value)
    }

    func encode(_ value: Double) throws {
        self.value = .double(value)
    }

    func encode(_ value: String) throws {
        self.value = .string(value)
    }

    func encode<T>(_ value: T) throws where T : Encodable {
        let encoder = _MessagePackEncoder()
        try value.encode(to: encoder)
        self.value = encoder.value
    }
}
