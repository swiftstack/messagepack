class MessagePackUnkeyedDecodingContainer
: UnkeyedDecodingContainer, SingleValueDecodingContainer {
    var codingPath: [CodingKey] {
        return []
    }

    var currentIndex: Int
    let array: [MessagePack]

    init(_ array: [MessagePack]) {
        self.array = array
        self.currentIndex = 0
    }

    var count: Int? {
        return array.count
    }

    var isAtEnd: Bool {
        return currentIndex == array.count
    }

    @inline(__always)
    private func inlinedDecode<T: MessagePackInitializable>(
        _ type: T.Type
    ) throws -> T {
        guard let value = T(array[currentIndex]) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: array[currentIndex]))
        }
        currentIndex += 1
        return value
    }

    @inline(__always)
    private func inlinedDecodeIfPresent<T: MessagePackInitializable>(
        _ type: T.Type
    ) throws -> T? {
        guard let value = T(array[currentIndex]) else {
            if case .nil = array[currentIndex] {
                currentIndex += 1
                return nil
            }
            throw DecodingError.typeMismatch(
                type, .incompatible(with: array[currentIndex]))
        }
        currentIndex += 1
        return value
    }

    func decodeNil() -> Bool {
        defer { currentIndex += 1 }
        guard case .nil = array[currentIndex] else {
            return false
        }
        return true
    }

    func decode(_ type: Int.Type) throws -> Int {
        return try inlinedDecode(type)
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        return try inlinedDecode(type)
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        return try inlinedDecode(type)
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        return try inlinedDecode(type)
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        return try inlinedDecode(type)
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        return try inlinedDecode(type)
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try inlinedDecode(type)
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try inlinedDecode(type)
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try inlinedDecode(type)
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try inlinedDecode(type)
    }

    func decode(_ type: Float.Type) throws -> Float {
        return try inlinedDecode(type)
    }

    func decode(_ type: Double.Type) throws -> Double {
        return try inlinedDecode(type)
    }

    func decode(_ type: String.Type) throws -> String {
        return try inlinedDecode(type)
    }

    func decode<T>(
        _ type: T.Type
    ) throws -> T where T : Decodable {
        let decoder = _MessagePackDecoder(array[currentIndex])
        let value = try T(from: decoder)
        currentIndex += 1
        return value
    }

    func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: String.Type) throws -> String? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent<T>(
        _ type: T.Type
    ) throws -> T? where T : Decodable {
        let decoder = _MessagePackDecoder(array[currentIndex])
        let value = try T(from: decoder)
        currentIndex += 1
        return value
    }

    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        guard case .map(let object) = array[currentIndex] else {
            throw DecodingError.typeMismatch([String : MessagePack].self, nil)
        }
        currentIndex += 1
        let container = MessagePackKeyedDecodingContainer<NestedKey>(object)
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case .array(let array) = array[currentIndex] else {
            throw DecodingError.typeMismatch([MessagePack].self, nil)
        }
        currentIndex += 1
        return MessagePackUnkeyedDecodingContainer(array)
    }

    func superDecoder() throws -> Decoder {
        return self
    }
}

// FIXME:
// Benchmark: implement decoder as class and store the reference for super
extension MessagePackUnkeyedDecodingContainer: Decoder {
    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    func container<Key>(
        keyedBy type: Key.Type
    ) throws -> KeyedDecodingContainer<Key> {
        fatalError("super mustn't request different container type")
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return self
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}
