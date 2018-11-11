extension Decoder {
    final class UnkeyedContainer:
        UnkeyedDecodingContainer,
        SingleValueDecodingContainer
    {
        var codingPath: [CodingKey] { return [] }

        var currentIndex: Int
        private let array: [MessagePack]

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
        private func _decode<T>(_ type: T.Type) throws -> T
            where T: MessagePackInitializable & Decodable
        {
            let value = array[currentIndex]
            guard let rawValue = T(value) else {
                throw Error.typeMismatch(requested: type, actual: value)
            }
            currentIndex += 1
            return rawValue
        }

        @inline(__always)
        private func _decodeIfPresent<T>(_ type: T.Type) throws -> T?
            where T: MessagePackInitializable & Decodable
        {
            let value = array[currentIndex]
            guard let rawValue = T(value) else {
                if case .nil = value {
                    currentIndex += 1
                    return nil
                }
                throw Error.typeMismatch(requested: type, actual: value)
            }
            currentIndex += 1
            return rawValue
        }

        func decodeNil() -> Bool {
            defer { currentIndex += 1 }
            guard case .nil = array[currentIndex] else {
                return false
            }
            return true
        }

        func decode(_ type: Int.Type) throws -> Int {
            return try _decode(type)
        }

        func decode(_ type: Int8.Type) throws -> Int8 {
            return try _decode(type)
        }

        func decode(_ type: Int16.Type) throws -> Int16 {
            return try _decode(type)
        }

        func decode(_ type: Int32.Type) throws -> Int32 {
            return try _decode(type)
        }

        func decode(_ type: Int64.Type) throws -> Int64 {
            return try _decode(type)
        }

        func decode(_ type: UInt.Type) throws -> UInt {
            return try _decode(type)
        }

        func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try _decode(type)
        }

        func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try _decode(type)
        }

        func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try _decode(type)
        }

        func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try _decode(type)
        }

        func decode(_ type: Float.Type) throws -> Float {
            return try _decode(type)
        }

        func decode(_ type: Double.Type) throws -> Double {
            return try _decode(type)
        }

        func decode(_ type: String.Type) throws -> String {
            return try _decode(type)
        }

        func decode<T: Decodable>(_ type: T.Type) throws -> T {
            let decoder = Decoder(array[currentIndex])
            let value = try T(from: decoder)
            currentIndex += 1
            return value
        }

        func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: Int.Type) throws -> Int? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: Float.Type) throws -> Float? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: Double.Type) throws -> Double? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent(_ type: String.Type) throws -> String? {
            return try _decodeIfPresent(type)
        }

        func decodeIfPresent<T: Decodable>(_ type: T.Type) throws -> T? {
            let decoder = Decoder(array[currentIndex])
            let value = try T(from: decoder)
            currentIndex += 1
            return value
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws ->
            KeyedDecodingContainer<NestedKey>
        {
            let value = array[currentIndex]
            guard case .map(let dictionary) = value else {
                throw Error.containerTypeMismatch(
                    requested: .keyed(by: type),
                    actual: value)
            }
            currentIndex += 1
            let container = KeyedContainer<NestedKey>(dictionary)
            return KeyedDecodingContainer(container)
        }

        func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let value = array[currentIndex]
            guard case .array(let array) = value else {
                throw Error.containerTypeMismatch(
                    requested: .unkeyed,
                    actual: value)
            }
            currentIndex += 1
            return UnkeyedContainer(array)
        }

        func superDecoder() throws -> Swift.Decoder {
            return self
        }
    }
}

extension Decoder.UnkeyedContainer: Swift.Decoder {
    var userInfo: [CodingUserInfoKey : Any] { return [:] }

    func container<Key>(keyedBy type: Key.Type) throws
        -> KeyedDecodingContainer<Key>
    {
        // can't convert unkeyed to keyed
        throw Decoder.Error.containerTypeMismatch(
            requested: .keyed(by: type),
            actual: self)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return self
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}
