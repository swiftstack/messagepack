extension MessagePack {
    public static func encode(_ object: MessagePack) -> [UInt8] {
        var writer = MessagePackWriter()
        writer.encode(object)
        return writer.bytes
    }

    public static func decode(bytes: [UInt8]) throws -> MessagePack {
        var reader = MessagePackReader(bytes: bytes, count: bytes.count)
        return try reader.decode() as MessagePack
    }

    public static func decode(
        buffer: UnsafeRawBufferPointer
    ) throws -> MessagePack {
        var reader = MessagePackReader(buffer: buffer)
        return try reader.decode()
    }

    public static func decode(
        bytes: UnsafeRawPointer, count: Int
    ) throws -> MessagePack {
        var reader = MessagePackReader(bytes: bytes, count: count)
        return try reader.decode()
    }
}
