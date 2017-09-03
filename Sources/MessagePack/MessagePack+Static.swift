extension MessagePack {
    public static func encode(_ object: MessagePack) -> [UInt8] {
        var encoder = RawMessagePackEncoder()
        encoder.encode(object)
        return encoder.bytes
    }

    public static func decode(bytes: [UInt8]) throws -> MessagePack {
        var decoder = UnsafeRawMessagePackDecoder(bytes: bytes, count: bytes.count)
        return try decoder.decode() as MessagePack
    }

    public static func decode(
        buffer: UnsafeRawBufferPointer
    ) throws -> MessagePack {
        var decoder = UnsafeRawMessagePackDecoder(buffer: buffer)
        return try decoder.decode()
    }

    public static func decode(
        bytes: UnsafeRawPointer, count: Int
    ) throws -> MessagePack {
        var decoder = UnsafeRawMessagePackDecoder(bytes: bytes, count: count)
        return try decoder.decode()
    }
}
