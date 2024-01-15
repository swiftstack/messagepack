import Stream

public struct MessagePackWriter {
    public var stream: StreamWriter

    typealias Error = MessagePack.Error

    public init(_ stream: StreamWriter) {
        self.stream = stream
    }

    mutating func write<T: FixedWidthInteger>(_ value: T) async throws {
        try await stream.write(value)
    }

    mutating func write(_ bytes: [UInt8]) async throws {
        try await stream.write(bytes)
    }
}

extension MessagePackWriter {
    mutating func write(code value: UInt8) async throws {
        try await write(value)
    }
}

// Encode

extension MessagePackWriter {
    public mutating func encode(_ value: MessagePack) async throws {
        switch value {
        case .`nil`: try await encodeNil()
        case let .int(value): try await encode(Int64(value))
        case let .uint(value): try await encode(UInt64(value))
        case let .bool(value): try await encode(value)
        case let .string(value): try await encode(value)
        case let .float(value): try await encode(value)
        case let .double(value): try await encode(value)
        case let .array(value): try await encode(value)
        case let .map(value): try await encode(value)
        case let .binary(value): try await encode(value)
        case let .extended(value): try await encode(value)
        }
    }
}

extension MessagePackWriter {
    public mutating func encode(_ array: [MessagePack]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array {
            try await encode(item)
        }
    }

    public mutating func encode(
        _ map: [MessagePack: MessagePack]
    ) async throws {
        try await writeMapHeader(count: map.count)
        for (key, value) in map {
            try await encode(key)
            try await encode(value)
        }
    }

    public mutating func encodeArrayItemsCount(_ itemsCount: Int) async throws {
        try await writeArrayHeader(count: itemsCount)
    }

    public mutating func encodeMapItemsCount(_ itemsCount: Int) async throws {
        try await writeMapHeader(count: itemsCount)
    }

    public mutating func encodeNil() async throws {
        try await write(UInt8(0xc0))
    }

    public mutating func encode(_ value: Int) async throws {
        try await encode(Int64(value))
    }

    public mutating func encode(_ value: UInt) async throws {
        try await encode(UInt64(value))
    }

    public mutating func encode(_ value: Bool) async throws {
        try await write(UInt8(value ? 0xc3 : 0xc2))
    }

    public mutating func encode(_ value: Float) async throws {
        try await write(code: 0xca)
        try await write(value.bitPattern)
    }

    public mutating func encode(_ value: Double) async throws {
        try await write(code: 0xcb)
        try await write(value.bitPattern)
    }

    public mutating func encode(_ value: String) async throws {
        let utf8 = Array(value.utf8)
        try await writeStringHeader(count: utf8.count)
        try await write(utf8)
    }

    public mutating func encode(_ binary: [UInt8]) async throws {
        try await writeBinaryHeader(count: binary.count)
        try await write(binary)
    }

    public mutating func encode(_ extended: MessagePack.Extended) async throws {
        try await writeExtendedHeader(
            type: extended.type,
            count: extended.data.count)
        try await write(extended.data)
    }

    public mutating func encode(_ value: Int8) async throws {
        switch value {
        case value where value >= 0:
            try await encode(UInt8(bitPattern: value))
        case value where value >= -0x20:
            try await write(code: 0xe0 + 0x1f & UInt8(bitPattern: value))
        default:
            try await write(code: 0xd0)
            try await write(value)
        }
    }

    public mutating func encode(_ value: Int16) async throws {
        switch value {
        case let value where value >= 0:
            try await encode(UInt16(bitPattern: value))
        case let value where value >= -0x7f:
            try await encode(Int8(truncatingIfNeeded: value))
        default:
            try await write(code: 0xd1)
            try await write(value)
        }
    }

    public mutating func encode(_ value: Int32) async throws {
        switch value {
        case let value where value >= 0:
            try await encode(UInt32(bitPattern: value))
        case let value where value >= -0x7fff:
            try await encode(Int16(truncatingIfNeeded: value))
        default:
            try await write(code: 0xd2)
            try await write(value)
        }
    }

    public mutating func encode(_ value: Int64) async throws {
        switch value {
        case let value where value >= 0:
            try await encode(UInt64(bitPattern: value))
        case let value where value >= -0x7fff_ffff:
            try await encode(Int32(truncatingIfNeeded: value))
        default:
            try await write(code: 0xd3)
            try await write(value)
        }
    }

    public mutating func encode(_ value: UInt8) async throws {
        switch value {
        case let value where value <= 0x7f:
            try await write(UInt8(value))
        default:
            try await write(code: 0xcc)
            try await write(value)
        }
    }

    public mutating func encode(_ value: UInt16) async throws {
        switch value {
        case let value where value <= 0xff:
            try await encode(UInt8(truncatingIfNeeded: value))
        default:
            try await write(code: 0xcd)
            try await write(value)
        }
    }

    public mutating func encode(_ value: UInt32) async throws {
        switch value {
        case let value where value <= 0xffff:
            try await encode(UInt16(truncatingIfNeeded: value))
        default:
            try await write(code: 0xce)
            try await write(value)
        }
    }

    public mutating func encode(_ value: UInt64) async throws {
        switch value {
        case let value where value <= 0xffff_ffff:
            try await encode(UInt32(truncatingIfNeeded: value))
        default:
            try await write(code: 0xcf)
            try await write(value)
        }
    }

    public mutating func encode(array: [Bool]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [Float]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [Double]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [String]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [Int]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [UInt]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [Int8]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [UInt8]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [Int16]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [UInt16]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [Int32]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [UInt32]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [Int64]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }

    public mutating func encode(array: [UInt64]) async throws {
        try await writeArrayHeader(count: array.count)
        for item in array { try await encode(item) }
    }
}

// Headers

extension MessagePackWriter {
    mutating func writeStringHeader(count: Int) async throws {
        switch count {
        case let count where count <= 0x19:
            try await write(code: 0xa0 | UInt8(count))
        case let count where count <= 0xff:
            try await write(code: 0xd9)
            try await write(UInt8(count))
        case let count where count <= 0xffff:
            try await write(code: 0xda)
            try await write(UInt16(count))
        default:
            try await write(code: 0xdb)
            try await write(UInt32(count))
        }
    }

    mutating func writeArrayHeader(count: Int) async throws {
        switch count {
        case let count where count <= 0xf:
            try await write(code: 0x90 | UInt8(count))
        case let count where count <= 0xffff:
            try await write(code: 0xdc)
            try await write(UInt16(count))
        default:
            try await write(code: 0xdd)
            try await write(UInt32(count))
        }
    }

    mutating func writeMapHeader(count: Int) async throws {
        switch count {
        case let count where count <= 0xf:
            try await write(code: 0x80 | UInt8(count))
        case let count where count <= 0xffff:
            try await write(code: 0xde)
            try await write(UInt16(count))
        default:
            try await write(code: 0xdf)
            try await write(UInt32(count))
        }
    }

    mutating func writeBinaryHeader(count: Int) async throws {
        switch count {
        case let count where count <= 0xff:
            try await write(code: 0xc4)
            try await write(UInt8(count))
        case let count where count <= 0xffff:
            try await write(code: 0xc5)
            try await write(UInt16(count))
        default:
            try await write(code: 0xc6)
            try await write(UInt32(count))
        }
    }

    mutating func writeExtendedHeader(type: Int8, count: Int) async throws {
        let type = UInt8(bitPattern: type)
        switch count {
        case 1:
            try await write(code: 0xd4)
        case 2:
            try await write(code: 0xd5)
        case 4:
            try await write(code: 0xd6)
        case 8:
            try await write(code: 0xd7)
        case 16:
            try await write(code: 0xd8)
        case let count where count <= 0xff:
            try await write(code: 0xc7)
            try await write(UInt8(count))
        case let count where count <= 0xffff:
            try await write(code: 0xc8)
            try await write(UInt16(count))
        default:
            try await write(code: 0xc9)
            try await write(UInt32(count))
        }
        try await write(type)
    }
}
