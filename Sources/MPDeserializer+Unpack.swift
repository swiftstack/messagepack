extension MPDeserializer {
    public mutating func unpack() throws -> MessagePack {
        let code = try readCode()
        switch code {
        // positive fixint
        case 0x00...0x7f: return .uint(try readUInt(code: code))
        // fixmap
        case 0x80...0x8f: return .map(try readMap(code: code))
        // fixarray: 8 bit lenght
        case 0x90...0x9f: return .array(try readArray(code: code))
        // fixstr: 8 bit length
        case 0xa0...0xbf: return .string(try readString(code: code))
        // nil
        case 0xc0: return .`nil`
        // bool
        case 0xc2...0xc3: return .bool(try readBool(code: code))
        // bin: 8,16,32 bit length
        case 0xc4...0xc6: return .binary(try readBinary(code: code))
        // ext 8,16,32 bit length
        case 0xc7...0xc9: return .extended(try readExtended(code: code))
        // float 32
        case 0xca: return .float(try readFloat())
        // float 64
        case 0xcb: return .double(try readDouble())
        // uint 8,16,32,64
        case 0xcc...0xcf: return .uint(try readUInt(code: code))
        // int 8,16,32,64
        case 0xd0...0xd3: return .int(try readInt(code: code))
        // fixext 1,2,4,8,16 bytes length
        case 0xd4...0xd8: return .extended(try readExtended(code: code))
        // str: 8,16,32 bit length
        case 0xd9...0xdb: return .string(try readString(code: code))
        // array: 16,32 bit length
        case 0xdc...0xdd: return .array(try readArray(code: code))
        // map: 16,32 bit length
        case 0xde...0xdf: return .map(try readMap(code: code))
        // negative fixint
        case 0xe0...0xff: return .int(try readInt(code: code))

        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> Int {
        let code = try readCode()
        return try readInt(code: code)
    }

    public mutating func unpack() throws -> UInt {
        let code = try readCode()
        return try readUInt(code: code)
    }

    public mutating func unpack() throws -> Bool {
        let code = try readCode()
        return try readBool(code: code)
    }

    public mutating func unpack() throws -> Float {
        switch try readCode() {
        case 0xca: return try readFloat()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> Double {
        switch try readCode() {
        case 0xcb: return try readDouble()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> String {
        let code = try readCode()
        switch code {
        case 0xa0...0xbf: fallthrough
        case 0xd9...0xdb: return try readString(code: code)
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> UInt8 {
        let code = try readCode()
        switch code {
        case 0x00...0x7f: return code
        case 0xcc: return try readUInt8()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> UInt16 {
        switch try readCode() {
        case 0xcd: return try readUInt16()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> UInt32 {
        switch try readCode() {
        case 0xce: return try readUInt32()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> UInt64 {
        switch try readCode() {
        case 0xcf: return try readUInt64()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> Int8 {
        let code = try readCode()
        switch code {
        case 0xe0...0xff: return Int8(numericCast(code) - 0x100)
        case 0xd0: return try readInt8()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> Int16 {
        switch try readCode() {
        case 0xd1: return try readInt16()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> Int32 {
        switch try readCode() {
        case 0xd2: return try readInt32()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> Int64 {
        switch try readCode() {
        case 0xd3: return try readInt64()
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> [MessagePack] {
        let code = try readCode()
        switch code {
        case 0x90...0x9f: fallthrough
        case 0xdc...0xdd: return try readArray(code: code)
        default: throw MessagePackError.invalidData
        }
    }

    public mutating func unpack() throws -> [MessagePack : MessagePack] {
        let code = try readCode()
        switch code {
        case 0x80...0x8f: fallthrough
        case 0xde...0xdf: return try readMap(code: code)
        default: throw MessagePackError.invalidData
        }
    }
}