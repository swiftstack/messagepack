import Stream

public struct MessagePackReader {
    var stream: StreamReader

    typealias Error = MessagePack.Error

    public init(_ stream: StreamReader) {
        self.stream = stream
    }

    mutating func read<T: FixedWidthInteger>(_ type: T.Type) throws -> T {
        return try stream.read(type)
    }

    mutating func read(count: Int) throws -> [UInt8] {
        return try stream.read(count: count)
    }
}

extension MessagePackReader {
    mutating func readCode() throws -> UInt8 {
        return try read(UInt8.self)
    }
}

extension MessagePackReader {
    mutating func readInt(code: UInt8) throws -> Int {
        switch code {
        case 0xd0: return Int(try read(Int8.self))
        case 0xd1: return Int(try read(Int16.self))
        case 0xd2: return Int(try read(Int32.self))
        case 0xd3: return Int(try read(Int64.self))
        case 0xe0...0xff: return Int(Int8(numericCast(code) - 0x100))
        default: throw Error.invalidData
        }
    }

    mutating func readUInt(code: UInt8) throws -> UInt {
        switch code {
        case 0x00...0x7f: return UInt(code)
        case 0xcc: return UInt(try read(UInt8.self))
        case 0xcd: return UInt(try read(UInt16.self))
        case 0xce: return UInt(try read(UInt32.self))
        case 0xcf: return UInt(try read(UInt64.self))
        default: throw Error.invalidData
        }
    }

    mutating func readBool(code: UInt8) throws -> Bool {
        switch code {
        case 0xc2: return false
        case 0xc3: return true
        default: throw Error.invalidData
        }
    }

    mutating func readFloat() throws -> Float {
        let bytes = try read(UInt32.self)
        return Float(bitPattern: bytes)
    }

    mutating func readDouble() throws -> Double {
        let bytes = try read(UInt64.self)
        return Double(bitPattern: bytes)
    }

    mutating func readString(code: UInt8) throws -> String {
        let count = try readStringHeader(code: code)
        let bytes = try read(count: count)
        return String(decoding: bytes, as: UTF8.self)
    }

    mutating func readArray(code: UInt8) throws -> [MessagePack] {
        let count = try readArrayHeader(code: code)
        var array = [MessagePack]()

        array.reserveCapacity(count)
        for _ in 0..<count {
            array.append(try decode())
        }

        return array
    }

    mutating func readMap(code: UInt8) throws -> [MessagePack: MessagePack] {
        let count = try readMapHeader(code: code)
        var dictionary = [MessagePack: MessagePack]()

        for _ in 0..<count {
            let key = try decode() as MessagePack
            let value = try decode() as MessagePack
            dictionary[key] = value
        }

        return dictionary
    }

    mutating func readBinary(code: UInt8) throws -> [UInt8] {
        let count = try readBinaryHeader(code: code)
        return [UInt8](try read(count: count))
    }

    mutating func readExtended(code: UInt8) throws -> MessagePack.Extended {
        let count = try readExtendedHeader(code: code)

        let type = try read(Int8.self)
        let data = [UInt8](try read(count: count))

        return MessagePack.Extended(type: type, data: data)
    }
}

extension MessagePackReader {
    public mutating func decode() throws -> MessagePack {
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

        default: throw Error.invalidData
        }
    }

    public mutating func decodeArrayItemsCount() throws -> Int {
        let code = try readCode()
        return try readArrayHeader(code: code)
    }

    public mutating func decodeMapItemsCount() throws -> Int {
        let code = try readCode()
        return try readMapHeader(code: code)
    }

    public mutating func decode(_ type: Int.Type) throws -> Int {
        let code = try readCode()
        // positive integers encoded as unsigned
        // since they're used more often,
        // we try to decode and convert it first
        if let unsigned = try? readUInt(code: code),
            unsigned <= UInt(Int.max) {
            return Int(unsigned)
        }
        return try readInt(code: code)
    }

    public mutating func decode(_ type: UInt.Type) throws -> UInt {
        let code = try readCode()
        return try readUInt(code: code)
    }

    public mutating func decode(_ type: Bool.Type) throws -> Bool {
        let code = try readCode()
        return try readBool(code: code)
    }

    public mutating func decode(_ type: Float.Type) throws -> Float {
        switch try readCode() {
        case 0xca: return try readFloat()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Double.Type) throws -> Double {
        switch try readCode() {
        case 0xcb: return try readDouble()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: String.Type) throws -> String {
        let code = try readCode()
        switch code {
        case 0xa0...0xbf: fallthrough
        case 0xd9...0xdb: return try readString(code: code)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        let code = try readCode()
        switch code {
        case 0x00...0x7f: return code
        case 0xcc: return try read(UInt8.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        switch try readCode() {
        case 0xcd: return try read(UInt16.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        switch try readCode() {
        case 0xce: return try read(UInt32.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        switch try readCode() {
        case 0xcf: return try read(UInt64.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int8.Type) throws -> Int8 {
        let code = try readCode()
        switch code {
        case 0xe0...0xff: return Int8(numericCast(code) - 0x100)
        case 0xd0: return try read(Int8.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int16.Type) throws -> Int16 {
        switch try readCode() {
        case 0xd1: return try read(Int16.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int32.Type) throws -> Int32 {
        switch try readCode() {
        case 0xd2: return try read(Int32.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int64.Type) throws -> Int64 {
        switch try readCode() {
        case 0xd3: return try read(Int64.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: [UInt8].Type) throws -> [UInt8] {
        let code = try readCode()
        switch code {
        case 0xc4...0xc6: return try readBinary(code: code)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(
        _ type: [MessagePack].Type
        ) throws -> [MessagePack] {
        let code = try readCode()
        switch code {
        case 0x90...0x9f: fallthrough
        case 0xdc...0xdd: return try readArray(code: code)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(
        _ type: [MessagePack : MessagePack].Type
        ) throws -> [MessagePack : MessagePack] {
        let code = try readCode()
        switch code {
        case 0x80...0x8f: fallthrough
        case 0xde...0xdf: return try readMap(code: code)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(
        _ type: MessagePack.Extended.Type
        ) throws -> MessagePack.Extended {
        let code = try readCode()
        switch code {
        case 0xc7...0xc9: fallthrough
        case 0xd4...0xd8: return try readExtended(code: code)
        default: throw Error.invalidData
        }
    }
}

// Headers

extension MessagePackReader {
    mutating func readStringHeader(code: UInt8) throws -> Int {
        switch code {
        case 0xa0...0xbf: return Int(code - 0xa0)
        case 0xd9: return Int(try read(UInt8.self))
        case 0xda: return Int(try read(UInt16.self))
        case 0xdb: return Int(try read(UInt32.self))
        default: throw Error.invalidData
        }
    }

    mutating func readArrayHeader(code: UInt8) throws -> Int {
        switch code {
        case 0x90...0x9f: return Int(code - 0x90)
        case 0xdc: return Int(try read(UInt16.self))
        case 0xdd: return Int(try read(UInt32.self))
        default: throw Error.invalidData
        }
    }

    mutating func readMapHeader(code: UInt8) throws -> Int {
        switch code {
        case 0x80...0x8f: return Int(code - 0x80)
        case 0xde: return Int(try read(UInt16.self))
        case 0xdf: return Int(try read(UInt32.self))
        default: throw Error.invalidData
        }
    }

    mutating func readBinaryHeader(code: UInt8) throws -> Int {
        switch code {
        case 0xc4: return Int(try read(UInt8.self))
        case 0xc5: return Int(try read(UInt16.self))
        case 0xc6: return Int(try read(UInt32.self))
        default: throw Error.invalidData
        }
    }

    mutating func readExtendedHeader(code: UInt8) throws -> Int {
        switch code {
        case 0xd4: return 1
        case 0xd5: return 2
        case 0xd6: return 4
        case 0xd7: return 8
        case 0xd8: return 16
        case 0xc7: return Int(try read(UInt8.self))
        case 0xc8: return Int(try read(UInt16.self))
        case 0xc9: return Int(try read(UInt32.self))
        default: throw Error.invalidData
        }
    }
}
