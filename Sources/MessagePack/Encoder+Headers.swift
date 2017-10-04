extension MessagePackWriter {
    mutating func writeStringHeader(count: Int) throws {
        precondition(count <= 0xffff_ffff)
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
        precondition(count <= 0xffff_ffff)
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
        precondition(count < 0xffff_ffff)
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
        precondition(count <= 0xffff_ffff)
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
        precondition(count <= 0xffff_ffff)
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
