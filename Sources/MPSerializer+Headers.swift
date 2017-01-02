extension MPSerializer {
    mutating func writeStringHeader(count: Int) {
        precondition(count <= 0xffff_ffff)
        switch count {
        case let count where count <= 0x19:
            write(code: 0xa0 | UInt8(count))
        case let count where count <= 0xff:
            write(code: 0xd9)
            write(UInt8(count))
        case let count where count <= 0xffff:
            write(code: 0xda)
            write(UInt16(count))
        default:
            write(code: 0xdb)
            write(UInt32(count))
        }
    }

    mutating func writeArrayHeader(count: Int) {
        precondition(count <= 0xffff_ffff)
        switch count {
        case let count where count <= 0xe:
            write(code: 0x90 | UInt8(count))
        case let count where count <= 0xffff:
            write(code: 0xdc)
            write(UInt16(count))
        default:
            write(code: 0xdd)
            write(UInt32(count))
        }
    }

    mutating func writeMapHeader(count: Int) {
        precondition(count < 0xffff_ffff)
        switch count {
        case let count where count <= 0xe:
            write(code: 0x80 | UInt8(count))
        case let count where count <= 0xffff:
            write(code: 0xde)
            write(UInt16(count))
        default:
            write(code: 0xdf)
            write(UInt32(count))
        }
    }

    mutating func writeBinaryHeader(count: Int) {
        precondition(count <= 0xffff_ffff)
        switch count {
        case let count where count <= 0xff:
            write(code: 0xc4)
            write(UInt8(count))
        case let count where count <= 0xffff:
            write(code: 0xc5)
            write(UInt16(count))
        default:
            write(code: 0xc6)
            write(UInt32(count))
        }
    }

    mutating func writeExtendedHeader(type: Int8, count: Int) {
        precondition(count <= 0xffff_ffff)
        let type = UInt8(bitPattern: type)
        switch count {
        case 1:
            write(code: 0xd4)
        case 2:
            write(code: 0xd5)
        case 4:
            write(code: 0xd6)
        case 8:
            write(code: 0xd7)
        case 16:
            write(code: 0xd8)
        case let count where count <= 0xff:
            write(code: 0xc7)
            write(UInt8(count))
        case let count where count <= 0xffff:
            write(code: 0xc8)
            write(UInt16(count))
        default:
            write(code: 0xc9)
            write(UInt32(count))
        }
        write(type)
    }
}
