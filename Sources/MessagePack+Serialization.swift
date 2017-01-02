extension MessagePack {
    /// Use MPSerializer() to pack multiple values
    public static func serialize(_ object: MessagePack) -> [UInt8] {
        var serializer = MPSerializer()
        serializer.pack(object)
        return serializer.bytes
    }

    /// Use MPDeserializer(bytes: [UInt8]) to unpack multiple values
    public static func deserialize(bytes: [UInt8]) throws -> MessagePack {
        var deserializer = MPDeserializer(bytes: bytes)
        return try deserializer.unpack() as MessagePack
    }

    /// Use MPDeserializer(bytesNoCopy: UnsafeBufferPointer<UInt8>) to unpack multiple values
    public static func deserialize(bytes: UnsafeBufferPointer<UInt8>) throws -> MessagePack {
        var deserializer = MPDeserializer(bytesNoCopy: bytes)
        return try deserializer.unpack()
    }

    /// Use MPDeserializer(bytesNoCopy: UnsafePointer<UInt8>, count: Int) to unpack multiple values
    public static func deserialize(bytes start: UnsafePointer<UInt8>, count: Int) throws -> MessagePack {
        var deserializer = MPDeserializer(bytesNoCopy: start, count: count)
        return try deserializer.unpack()
    }
}
