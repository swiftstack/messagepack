extension MPSerializer {
    public mutating func pack(_ array: [MessagePack]) {
        writeArrayHeader(count: array.count)
        for item in array {
            pack(item)
        }
    }

    public mutating func pack(_ dictionary: [MessagePack: MessagePack]) {
        writeMapHeader(count: dictionary.count)
        for (key, value) in dictionary {
            pack(key)
            pack(value)
        }
    }

    public mutating func pack(_ value: MessagePack) {
        switch value {
        case .`nil`: packNil()
        case let .int(value): pack(Int64(value))
        case let .uint(value): pack(UInt64(value))
        case let .bool(value): pack(value)
        case let .string(value): pack(value)
        case let .float(value): pack(value)
        case let .double(value): pack(value)
        case let .array(value): pack(value)
        case let .map(value): pack(value)
        case let .binary(value): pack(binary: value)
        case let .extended(value): pack(extended: value)
        }
    }

    public mutating func packNil() {
        write(UInt8(0xc0))
    }

    public mutating func pack(_ value: Int) {
        pack(Int64(value))
    }

    public mutating func pack(_ value: UInt) {
        pack(UInt64(value))
    }

    public mutating func pack(_ value: Bool) {
        write(UInt8(value ? 0xc3 : 0xc2))
    }

    public mutating func pack(_ value: Float) {
        write(code: 0xca)
        write(unsafeBitCast(value, to: UInt32.self))
    }

    public mutating func pack(_ value: Double) {
        write(code: 0xcb)
        write(unsafeBitCast(value, to: UInt64.self))
    }

    public mutating func pack(_ value: String) {
        let utf8 = Array(value.utf8)
        writeStringHeader(count: utf8.count)
        write(utf8)
    }

    public mutating func pack(binary: [UInt8]) {
        writeBinaryHeader(count: binary.count)
        write(binary)
    }

    public mutating func pack(extended: MessagePack.Extended) {
        writeExtendedHeader(type: extended.type, count: extended.data.count)
        write(extended.data)
    }

    public mutating func pack(_ value: Int8) {
        switch value {
        case value where value >= 0:
            pack(UInt8(bitPattern: value))
        case value where value >= -0x20:
            write(code: 0xe0 + 0x1f & UInt8(bitPattern: value))
        default:
            write(code: 0xd0)
            write(value)
        }
    }

    public mutating func pack(_ value: Int16) {
        switch value {
        case let value where value >= 0:
            pack(UInt16(bitPattern: value))
        case let value where value >= -0x7f:
            pack(Int8(truncatingBitPattern: value))
        default:
            write(code: 0xd1)
            write(value)
        }
    }

    public mutating func pack(_ value: Int32) {
        switch value {
        case let value where value >= 0:
            pack(UInt32(bitPattern: value))
        case let value where value >= -0x7fff:
            pack(Int16(truncatingBitPattern: value))
        default:
            write(code: 0xd2)
            write(value)
        }
    }

    public mutating func pack(_ value: Int64) {
        switch value {
        case let value where value >= 0:
            pack(UInt64(bitPattern: value))
        case let value where value >= -0x7fff_ffff:
            pack(Int32(truncatingBitPattern: value))
        default:
            write(code: 0xd3)
            write(value)
        }
    }

    public mutating func pack(_ value: UInt8) {
        switch value {
        case let value where value <= 0x7f:
            write(UInt8(value))
        default:
            write(code: 0xcc)
            write(value)
        }
    }

    public mutating func pack(_ value: UInt16) {
        switch value {
        case let value where value <= 0xff:
            pack(UInt8(truncatingBitPattern: value))
        default:
            write(code: 0xcd)
            write(value)
        }
    }

    public mutating func pack(_ value: UInt32) {
        switch value {
        case let value where value <= 0xffff:
            pack(UInt16(truncatingBitPattern: value))
        default:
            write(code: 0xce)
            write(value)
        }
    }

    public mutating func pack(_ value: UInt64) {
        switch value {
        case let value where value <= 0xffff_ffff:
            pack(UInt32(truncatingBitPattern: value))
        default:
            write(code: 0xcf)
            write(value)
        }
    }

    public mutating func pack(array: [Bool]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [Float]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [Double]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [String]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [Int]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [UInt]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [Int8]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [UInt8]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [Int16]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [UInt16]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [Int32]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [UInt32]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [Int64]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }

    public mutating func pack(array: [UInt64]) {
        writeArrayHeader(count: array.count)
        for item in array { pack(item) }
    }
}
