import Stream

extension MessagePack {
    public static func encode(_ object: MessagePack) throws -> [UInt8] {
        var writer = MessagePackWriter(OutputByteStream())
        try writer.encode(object)
        return writer.stream.bytes
    }

    public static func decode(bytes: [UInt8]) throws -> MessagePack {
        var reader = MessagePackReader(InputByteStream(bytes))
        return try reader.decode()
    }

    public static func encode<T: OutputStream>(
        _ object: MessagePack,
        to stream: T
    ) throws {
        var writer = MessagePackWriter(stream)
        try writer.encode(object)
    }

    public static func decode<T: InputStream>(
        from stream: T
    ) throws -> MessagePack {
        var reader = MessagePackReader(stream)
        return try reader.decode()
    }
}
