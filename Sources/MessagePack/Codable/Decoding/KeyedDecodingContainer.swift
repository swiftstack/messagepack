extension Decoder {
    struct KeyedContainer<Key : CodingKey>: KeyedDecodingContainerProtocol {
        var codingPath: [CodingKey] { return [] }

        var allKeys: [Key] {
            return dictionary.keys.compactMap(Key.init)
        }

        private let dictionary: [MessagePack : MessagePack]

        init(_ dictionary: [MessagePack : MessagePack]) {
            self.dictionary = dictionary
        }

        func contains(_ key: Key) -> Bool {
            return dictionary[key] != nil
        }

        @inline(__always)
        private func _decode<T>(
            _ type: T.Type,
            forKey key: Key) throws -> T
            where T: MessagePackInitializable & Decodable
        {
            guard let value = dictionary[key] else {
                throw Error.keyNotFound(key)
            }
            guard let rawValue = T(value) else {
                throw Error.typeMismatch(
                    forKey: key,
                    requested: type,
                    actual: value)
            }
            return rawValue
        }

        @inline(__always)
        private func _decodeIfPresent<T>(
            _ type: T.Type,
            forKey key: Key) throws -> T?
            where T: MessagePackInitializable & Decodable
        {
            guard let value = dictionary[key] else {
                return nil
            }
            guard let rawValue = T(value) else {
                if case .nil = value {
                    return nil
                }
                throw Error.typeMismatch(
                    forKey: key,
                    requested: type,
                    actual: value)
            }
            return rawValue
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            if let value = dictionary[key], case .nil = value {
                return true
            }
            return false
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            return try _decode(type, forKey: key)
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            return try _decode(type, forKey: key)
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T
            where T: Decodable
        {
            guard let value = dictionary[key] else {
                throw Error.keyNotFound(key)
            }
            let decoder = Decoder(value)
            return try T(from: decoder)
        }

        func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
            return try _decodeIfPresent(type, forKey: key)
        }

        func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T?
            where T: Decodable
        {
            guard let value = dictionary[key] else {
                return nil
            }
            let decoder = Decoder(value)
            return try T(from: decoder)
        }

        func nestedContainer<NestedKey>(
            keyedBy type: NestedKey.Type,
            forKey key: Key) throws -> KeyedDecodingContainer<NestedKey>
        {
            guard let container = dictionary[key] else {
                throw Error.keyNotFound(key)
            }
            guard case .map(let dictionary) = container else {
                throw Error.containerTypeMismatch(
                    requested: .keyed(by: type, for: key),
                    actual: container)
            }
            let keyedContainer = KeyedContainer<NestedKey>(dictionary)
            return KeyedDecodingContainer(keyedContainer)
        }

        func nestedUnkeyedContainer(forKey key: Key) throws
            -> UnkeyedDecodingContainer
        {
            guard let container = dictionary[key] else {
                throw Error.keyNotFound(key)
            }
            guard case .array(let array) = container else {
                throw Error.containerTypeMismatch(
                    requested: .unkeyed(for: key),
                    actual: container)
            }
            return UnkeyedContainer(array)
        }

        func superDecoder() throws -> Swift.Decoder {
            return Decoder(.map(dictionary))
        }

        func superDecoder(forKey key: Key) throws -> Swift.Decoder {
            guard let container = dictionary[key] else {
                throw Error.keyNotFound(key)
            }
            return Decoder(container)
        }
    }
}
