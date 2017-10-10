import Stream

public struct MessagePackWriter<T: OutputStream> {
    public var stream: T

    typealias Error = MessagePack.Error

    public init(_ stream: T) {
        self.stream = stream
    }

    mutating func write(_ value: UInt8) throws {
        var value = value
        try withUnsafeBytes(of: &value) { bytes in
            guard try stream.write(bytes) == 1 else {
                throw Error.streamWriteError
            }
        }
    }

    mutating func write(_ value: UInt16) throws {
        var value = value.byteSwapped
        try withUnsafeBytes(of: &value) { bytes in
            guard try stream.write(bytes) == 2 else {
                throw Error.streamWriteError
            }
        }
    }

    mutating func write(_ value: UInt32) throws {
        var value = value.byteSwapped
        try withUnsafeBytes(of: &value) { bytes in
            guard try stream.write(bytes) == 4 else {
                throw Error.streamWriteError
            }
        }
    }

    mutating func write(_ value: UInt64) throws {
        var value = value.byteSwapped
        try withUnsafeBytes(of: &value) { bytes in
            guard try stream.write(bytes) == 8 else {
                throw Error.streamWriteError
            }
        }
    }

    mutating func write(_ bytes: [UInt8]) throws {
        guard try stream.write(bytes) == bytes.count else {
            throw Error.streamWriteError
        }
    }
}

extension MessagePackWriter {
    mutating func write(_ value: Int8) throws {
        try write(UInt8(bitPattern: value))
    }

    mutating func write(_ value: Int16) throws {
        try write(UInt16(bitPattern: value))
    }

    mutating func write(_ value: Int32) throws {
        try write(UInt32(bitPattern: value))
    }

    mutating func write(_ value: Int64) throws {
        try write(UInt64(bitPattern: value))
    }
}

extension MessagePackWriter {
    mutating func write(code value: UInt8) throws {
        try write(value)
    }
}

// Encode

extension MessagePackWriter {
    public mutating func encode(_ value: MessagePack) throws {
        switch value {
        case .`nil`: try encodeNil()
        case let .int(value): try encode(Int64(value))
        case let .uint(value): try encode(UInt64(value))
        case let .bool(value): try encode(value)
        case let .string(value): try encode(value)
        case let .float(value): try encode(value)
        case let .double(value): try encode(value)
        case let .array(value): try encode(value)
        case let .map(value): try encode(value)
        case let .binary(value): try encode(value)
        case let .extended(value): try encode(value)
        }
    }
}

extension MessagePackWriter {
    public mutating func encode(_ array: [MessagePack]) throws {
        try writeArrayHeader(count: array.count)
        for item in array {
            try encode(item)
        }
    }

    public mutating func encode(_ dictionary: [MessagePack : MessagePack]) throws {
        try writeMapHeader(count: dictionary.count)
        for (key, value) in dictionary {
            try encode(key)
            try encode(value)
        }
    }

    public mutating func encodeArrayItemsCount(_ itemsCount: Int) throws {
        try writeArrayHeader(count: itemsCount)
    }

    public mutating func encodeMapItemsCount(_ itemsCount: Int) throws {
        try writeMapHeader(count: itemsCount)
    }

    public mutating func encodeNil() throws {
        try write(UInt8(0xc0))
    }

    public mutating func encode(_ value: Int) throws {
        try encode(Int64(value))
    }

    public mutating func encode(_ value: UInt) throws {
        try encode(UInt64(value))
    }

    public mutating func encode(_ value: Bool) throws {
        try write(UInt8(value ? 0xc3 : 0xc2))
    }

    public mutating func encode(_ value: Float) throws {
        try write(code: 0xca)
        try write(value.bitPattern)
    }

    public mutating func encode(_ value: Double) throws {
        try write(code: 0xcb)
        try write(value.bitPattern)
    }

    public mutating func encode(_ value: String) throws {
        let utf8 = Array(value.utf8)
        try writeStringHeader(count: utf8.count)
        try write(utf8)
    }

    public mutating func encode(_ binary: [UInt8]) throws {
        try writeBinaryHeader(count: binary.count)
        try write(binary)
    }

    public mutating func encode(_ extended: MessagePack.Extended) throws {
        try writeExtendedHeader(type: extended.type, count: extended.data.count)
        try write(extended.data)
    }

    public mutating func encode(_ value: Int8) throws {
        switch value {
        case value where value >= 0:
            try encode(UInt8(bitPattern: value))
        case value where value >= -0x20:
            try write(code: 0xe0 + 0x1f & UInt8(bitPattern: value))
        default:
            try write(code: 0xd0)
            try write(value)
        }
    }

    public mutating func encode(_ value: Int16) throws {
        switch value {
        case let value where value >= 0:
            try encode(UInt16(bitPattern: value))
        case let value where value >= -0x7f:
            try encode(Int8(truncatingIfNeeded: value))
        default:
            try write(code: 0xd1)
            try write(value)
        }
    }

    public mutating func encode(_ value: Int32) throws {
        switch value {
        case let value where value >= 0:
            try encode(UInt32(bitPattern: value))
        case let value where value >= -0x7fff:
            try encode(Int16(truncatingIfNeeded: value))
        default:
            try write(code: 0xd2)
            try write(value)
        }
    }

    public mutating func encode(_ value: Int64) throws {
        switch value {
        case let value where value >= 0:
            try encode(UInt64(bitPattern: value))
        case let value where value >= -0x7fff_ffff:
            try encode(Int32(truncatingIfNeeded: value))
        default:
            try write(code: 0xd3)
            try write(value)
        }
    }

    public mutating func encode(_ value: UInt8) throws {
        switch value {
        case let value where value <= 0x7f:
            try write(UInt8(value))
        default:
            try write(code: 0xcc)
            try write(value)
        }
    }

    public mutating func encode(_ value: UInt16) throws {
        switch value {
        case let value where value <= 0xff:
            try encode(UInt8(truncatingIfNeeded: value))
        default:
            try write(code: 0xcd)
            try write(value)
        }
    }

    public mutating func encode(_ value: UInt32) throws {
        switch value {
        case let value where value <= 0xffff:
            try encode(UInt16(truncatingIfNeeded: value))
        default:
            try write(code: 0xce)
            try write(value)
        }
    }

    public mutating func encode(_ value: UInt64) throws {
        switch value {
        case let value where value <= 0xffff_ffff:
            try encode(UInt32(truncatingIfNeeded: value))
        default:
            try write(code: 0xcf)
            try write(value)
        }
    }

    public mutating func encode(array: [Bool]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [Float]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [Double]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [String]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [Int]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [UInt]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [Int8]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [UInt8]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [Int16]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [UInt16]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [Int32]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [UInt32]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [Int64]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }

    public mutating func encode(array: [UInt64]) throws {
        try writeArrayHeader(count: array.count)
        for item in array { try encode(item) }
    }
}

// Headers

extension MessagePackWriter {
    mutating func writeStringHeader(count: Int) throws {
        switch count {
        case let count where count <= 0x19:
            try write(code: 0xa0 | UInt8(count))
        case let count where count <= 0xff:
            try write(code: 0xd9)
            try write(UInt8(count))
        case let count where count <= 0xffff:
            try write(code: 0xda)
            try write(UInt16(count))
        default:
            try write(code: 0xdb)
            try write(UInt32(count))
        }
    }

    mutating func writeArrayHeader(count: Int) throws {
        switch count {
        case let count where count <= 0xf:
            try write(code: 0x90 | UInt8(count))
        case let count where count <= 0xffff:
            try write(code: 0xdc)
            try write(UInt16(count))
        default:
            try write(code: 0xdd)
            try write(UInt32(count))
        }
    }

    mutating func writeMapHeader(count: Int) throws {
        switch count {
        case let count where count <= 0xf:
            try write(code: 0x80 | UInt8(count))
        case let count where count <= 0xffff:
            try write(code: 0xde)
            try write(UInt16(count))
        default:
            try write(code: 0xdf)
            try write(UInt32(count))
        }
    }

    mutating func writeBinaryHeader(count: Int) throws {
        switch count {
        case let count where count <= 0xff:
            try write(code: 0xc4)
            try write(UInt8(count))
        case let count where count <= 0xffff:
            try write(code: 0xc5)
            try write(UInt16(count))
        default:
            try write(code: 0xc6)
            try write(UInt32(count))
        }
    }

    mutating func writeExtendedHeader(type: Int8, count: Int) throws {
        let type = UInt8(bitPattern: type)
        switch count {
        case 1:
            try write(code: 0xd4)
        case 2:
            try write(code: 0xd5)
        case 4:
            try write(code: 0xd6)
        case 8:
            try write(code: 0xd7)
        case 16:
            try write(code: 0xd8)
        case let count where count <= 0xff:
            try write(code: 0xc7)
            try write(UInt8(count))
        case let count where count <= 0xffff:
            try write(code: 0xc8)
            try write(UInt16(count))
        default:
            try write(code: 0xc9)
            try write(UInt32(count))
        }
        try write(type)
    }
}
