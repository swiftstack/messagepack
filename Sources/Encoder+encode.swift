extension Encoder {
    public mutating func encode(_ value: MessagePack) {
        switch value {
        case .`nil`: encodeNil()
        case let .int(value): encode(Int64(value))
        case let .uint(value): encode(UInt64(value))
        case let .bool(value): encode(value)
        case let .string(value): encode(value)
        case let .float(value): encode(value)
        case let .double(value): encode(value)
        case let .array(value): encode(value)
        case let .map(value): encode(value)
        case let .binary(value): encode(binary: value)
        case let .extended(value): encode(extended: value)
        }
    }

    public mutating func encode(_ array: [MessagePack]) {
        writeArrayHeader(count: array.count)
        for item in array {
            encode(item)
        }
    }

    public mutating func encode(_ dictionary: [MessagePack : MessagePack]) {
        writeMapHeader(count: dictionary.count)
        for (key, value) in dictionary {
            encode(key)
            encode(value)
        }
    }

    public mutating func encodeNil() {
        write(UInt8(0xc0))
    }

    public mutating func encode(_ value: Int) {
        encode(Int64(value))
    }

    public mutating func encode(_ value: UInt) {
        encode(UInt64(value))
    }

    public mutating func encode(_ value: Bool) {
        write(UInt8(value ? 0xc3 : 0xc2))
    }

    public mutating func encode(_ value: Float) {
        write(code: 0xca)
        write(value.bitPattern)
    }

    public mutating func encode(_ value: Double) {
        write(code: 0xcb)
        write(value.bitPattern)
    }

    public mutating func encode(_ value: String) {
        let utf8 = Array(value.utf8)
        writeStringHeader(count: utf8.count)
        write(utf8)
    }

    public mutating func encode(binary: [UInt8]) {
        writeBinaryHeader(count: binary.count)
        write(binary)
    }

    public mutating func encode(extended: MessagePack.Extended) {
        writeExtendedHeader(type: extended.type, count: extended.data.count)
        write(extended.data)
    }

    public mutating func encode(_ value: Int8) {
        switch value {
        case value where value >= 0:
            encode(UInt8(bitPattern: value))
        case value where value >= -0x20:
            write(code: 0xe0 + 0x1f & UInt8(bitPattern: value))
        default:
            write(code: 0xd0)
            write(value)
        }
    }

    public mutating func encode(_ value: Int16) {
        switch value {
        case let value where value >= 0:
            encode(UInt16(bitPattern: value))
        case let value where value >= -0x7f:
            encode(Int8(truncatingBitPattern: value))
        default:
            write(code: 0xd1)
            write(value)
        }
    }

    public mutating func encode(_ value: Int32) {
        switch value {
        case let value where value >= 0:
            encode(UInt32(bitPattern: value))
        case let value where value >= -0x7fff:
            encode(Int16(truncatingBitPattern: value))
        default:
            write(code: 0xd2)
            write(value)
        }
    }

    public mutating func encode(_ value: Int64) {
        switch value {
        case let value where value >= 0:
            encode(UInt64(bitPattern: value))
        case let value where value >= -0x7fff_ffff:
            encode(Int32(truncatingBitPattern: value))
        default:
            write(code: 0xd3)
            write(value)
        }
    }

    public mutating func encode(_ value: UInt8) {
        switch value {
        case let value where value <= 0x7f:
            write(UInt8(value))
        default:
            write(code: 0xcc)
            write(value)
        }
    }

    public mutating func encode(_ value: UInt16) {
        switch value {
        case let value where value <= 0xff:
            encode(UInt8(truncatingBitPattern: value))
        default:
            write(code: 0xcd)
            write(value)
        }
    }

    public mutating func encode(_ value: UInt32) {
        switch value {
        case let value where value <= 0xffff:
            encode(UInt16(truncatingBitPattern: value))
        default:
            write(code: 0xce)
            write(value)
        }
    }

    public mutating func encode(_ value: UInt64) {
        switch value {
        case let value where value <= 0xffff_ffff:
            encode(UInt32(truncatingBitPattern: value))
        default:
            write(code: 0xcf)
            write(value)
        }
    }

    public mutating func encode(array: [Bool]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [Float]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [Double]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [String]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [Int]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [UInt]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [Int8]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [UInt8]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [Int16]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [UInt16]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [Int32]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [UInt32]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [Int64]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }

    public mutating func encode(array: [UInt64]) {
        writeArrayHeader(count: array.count)
        for item in array { encode(item) }
    }
}
