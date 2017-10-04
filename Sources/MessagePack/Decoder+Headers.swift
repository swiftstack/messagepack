extension MessagePackReader {
    mutating func readStringHeader(code: UInt8) throws -> Int {
        switch code {
        case 0xa0...0xbf: return Int(code - 0xa0)
        case 0xd9: return Int(try readUInt8())
        case 0xda: return Int(try readUInt16())
        case 0xdb: return Int(try readUInt32())
        default: throw MessagePackError.invalidData
        }
    }

    mutating func readArrayHeader(code: UInt8) throws -> Int {
        switch code {
        case 0x90...0x9f: return Int(code - 0x90)
        case 0xdc: return Int(try readUInt16())
        case 0xdd: return Int(try readUInt32())
        default: throw MessagePackError.invalidData
        }
    }

    mutating func readMapHeader(code: UInt8) throws -> Int {
        switch code {
        case 0x80...0x8f: return Int(code - 0x80)
        case 0xde: return Int(try readUInt16())
        case 0xdf: return Int(try readUInt32())
        default: throw MessagePackError.invalidData
        }
    }

    mutating func readBinaryHeader(code: UInt8) throws -> Int {
        switch code {
        case 0xc4: return Int(try readUInt8())
        case 0xc5: return Int(try readUInt16())
        case 0xc6: return Int(try readUInt32())
        default: throw MessagePackError.invalidData
        }
    }

    mutating func readExtendedHeader(code: UInt8) throws -> Int {
        switch code {
        case 0xd4: return 1
        case 0xd5: return 2
        case 0xd6: return 4
        case 0xd7: return 8
        case 0xd8: return 16
        case 0xc7: return Int(try readUInt8())
        case 0xc8: return Int(try readUInt16())
        case 0xc9: return Int(try readUInt32())
        default: throw MessagePackError.invalidData
        }
    }
}
