import Stream

// MARK: Generic <-> Stream

extension MessagePack {
    public static func decode<Model: Decodable>(
        _ type: Model.Type,
        from stream: StreamReader) async throws -> Model
    {
        let messagepack = try await MessagePack.decode(from: stream)
        let decoder = Decoder(messagepack)
        return try Model(from: decoder)
    }

    public static func encode<Model: Encodable>(
        _ value: Model,
        to stream: StreamWriter) async throws
    {
        let encoder = Encoder()
        try value.encode(to: encoder)
        try await MessagePack.encode(encoder.value, to: stream)
    }
}

// MARK: Codable <-> Stream

extension MessagePack {
    public static func decode(
        decodable type: Decodable.Type,
        from stream: StreamReader) async throws -> Decodable
    {
        let messagepack = try await MessagePack.decode(from: stream)
        let decoder = Decoder(messagepack)
        return try type.init(from: decoder)
    }

    public static func encode(
        encodable value: Encodable,
        to stream: StreamWriter) async throws
    {
        let encoder = Encoder()
        try value.encode(to: encoder)
        try await MessagePack.encode(encoder.value, to: stream)
    }
}

// MARK: Codable <-> [UInt8]

extension MessagePack {
    public static func encode<T: Encodable>(_ value: T) async throws -> [UInt8] {
        let stream = OutputByteStream()
        try await encode(value, to: stream)
        return stream.bytes
    }

    public static func decode<T: Decodable>(
        _ type: T.Type,
        from json: [UInt8]) async throws -> T
    {
        return try await decode(type, from: InputByteStream(json))
    }

    public static func encode(encodable value: Encodable) async throws -> [UInt8] {
        let stream = OutputByteStream()
        try await encode(encodable: value, to: stream)
        return stream.bytes
    }

    public static func decode(
        decodable type: Decodable.Type,
        from json: [UInt8]) async throws -> Decodable
    {
        return try await decode(decodable: type, from: InputByteStream(json))
    }
}

// MARK: MessagePack <-> Stream

extension MessagePack {
    public static func encode(
        _ object: MessagePack,
        to stream: StreamWriter) async throws
    {
        var writer = MessagePackWriter(stream)
        try await writer.encode(object)
    }

    public static func decode(
        from stream: StreamReader) async throws -> MessagePack
    {
        var reader = MessagePackReader(stream)
        return try await reader.decode()
    }
}

// MARK: MessagePack <-> [UInt8]

extension MessagePack {
    public static func encode(_ object: MessagePack) async throws -> [UInt8] {
        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try await writer.encode(object)
        return stream.bytes
    }

    public static func decode(bytes: [UInt8]) async throws -> MessagePack {
        var reader = MessagePackReader(InputByteStream(bytes))
        return try await reader.decode()
    }
}
