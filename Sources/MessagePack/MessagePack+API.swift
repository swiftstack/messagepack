import Stream

// MARK: Generic <-> Stream

extension MessagePack {
    public static func decode<Model: Decodable>(
        _ type: Model.Type,
        from stream: StreamReader) throws -> Model
    {
        let messagepack = try MessagePack.decode(from: stream)
        let decoder = Decoder(messagepack)
        return try Model(from: decoder)
    }

    public static func encode<Model: Encodable>(
        _ value: Model,
        to stream: StreamWriter) throws
    {
        let encoder = Encoder()
        try value.encode(to: encoder)
        try MessagePack.encode(encoder.value, to: stream)
    }
}

// MARK: Codable <-> Stream

extension MessagePack {
    public static func decode(
        decodable type: Decodable.Type,
        from stream: StreamReader) throws -> Decodable
    {
        let messagepack = try MessagePack.decode(from: stream)
        let decoder = Decoder(messagepack)
        return try type.init(from: decoder)
    }

    public static func encode(
        encodable value: Encodable,
        to stream: StreamWriter) throws
    {
        let encoder = Encoder()
        try value.encode(to: encoder)
        try MessagePack.encode(encoder.value, to: stream)
    }
}

// MARK: Codable <-> [UInt8]

extension MessagePack {
    public static func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        let stream = OutputByteStream()
        try encode(value, to: stream)
        return stream.bytes
    }

    public static func decode<T: Decodable>(
        _ type: T.Type,
        from json: [UInt8]) throws -> T
    {
        return try decode(type, from: InputByteStream(json))
    }

    public static func encode(encodable value: Encodable) throws -> [UInt8] {
        let stream = OutputByteStream()
        try encode(encodable: value, to: stream)
        return stream.bytes
    }

    public static func decode(
        decodable type: Decodable.Type,
        from json: [UInt8]) throws -> Decodable
    {
        return try decode(decodable: type, from: InputByteStream(json))
    }
}

// MARK: MessagePack <-> Stream

extension MessagePack {
    public static func encode(
        _ object: MessagePack,
        to stream: StreamWriter) throws
    {
        var writer = MessagePackWriter(stream)
        try writer.encode(object)
    }

    public static func decode(
        from stream: StreamReader) throws -> MessagePack
    {
        var reader = MessagePackReader(stream)
        return try reader.decode()
    }
}

// MARK: MessagePack <-> [UInt8]

extension MessagePack {
    public static func encode(_ object: MessagePack) throws -> [UInt8] {
        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encode(object)
        return stream.bytes
    }

    public static func decode(bytes: [UInt8]) throws -> MessagePack {
        var reader = MessagePackReader(InputByteStream(bytes))
        return try reader.decode()
    }
}
