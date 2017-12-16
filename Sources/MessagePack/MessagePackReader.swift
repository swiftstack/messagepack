import Stream

public struct MessagePackReader<T: InputStream> {
    var stream: T

    typealias Error = MessagePack.Error

    public init(_ stream: T) {
        self.stream = stream
    }

    mutating func readUInt8() throws -> UInt8 {
        var result: UInt8 = 0
        guard try stream.read(to: &result, byteCount: 1) == 1 else {
            throw Error.insufficientData
        }
        return result
    }

    mutating func readUInt16() throws -> UInt16 {
        var result: UInt16 = 0
        guard try stream.read(to: &result, byteCount: 2) == 2 else {
            throw Error.insufficientData
        }
        return result.byteSwapped
    }

    mutating func readUInt32() throws -> UInt32 {
        var result: UInt32 = 0
        guard try stream.read(to: &result, byteCount: 4) == 4 else {
            throw Error.insufficientData
        }
        return result.byteSwapped
    }

    mutating func readUInt64() throws -> UInt64 {
        var result: UInt64 = 0
        guard try stream.read(to: &result, byteCount: 8) == 8 else {
            throw Error.insufficientData
        }
        return result.byteSwapped
    }

    mutating func read(count: Int) throws -> [UInt8] {
        var result = [UInt8](repeating: 0, count: count)
        guard try stream.read(to: &result) == count else {
            throw Error.insufficientData
        }
        return result
    }
}

extension MessagePackReader {
    mutating func readInt8() throws -> Int8 {
        return Int8(bitPattern: try readUInt8())
    }

    mutating func readInt16() throws -> Int16 {
        return Int16(bitPattern: try readUInt16())
    }

    mutating func readInt32() throws -> Int32 {
        return Int32(bitPattern: try readUInt32())
    }

    mutating func readInt64() throws -> Int64 {
        return Int64(bitPattern: try readUInt64())
    }
}

extension MessagePackReader {
    mutating func readCode() throws -> UInt8 {
        return try readUInt8()
    }
}

extension MessagePackReader {
    mutating func readInt(code: UInt8) throws -> Int {
        switch code {
        case 0xd0: return Int(try readInt8())
        case 0xd1: return Int(try readInt16())
        case 0xd2: return Int(try readInt32())
        case 0xd3: return Int(try readInt64())
        case 0xe0...0xff: return Int(Int8(numericCast(code) - 0x100))
        default: throw Error.invalidData
        }
    }

    mutating func readUInt(code: UInt8) throws -> UInt {
        switch code {
        case 0x00...0x7f: return UInt(code)
        case 0xcc: return UInt(try readUInt8())
        case 0xcd: return UInt(try readUInt16())
        case 0xce: return UInt(try readUInt32())
        case 0xcf: return UInt(try readUInt64())
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
        let bytes = try readUInt32()
        return Float(bitPattern: bytes)
    }

    mutating func readDouble() throws -> Double {
        let bytes = try readUInt64()
        return Double(bitPattern: bytes)
    }

    mutating func readString(code: UInt8) throws -> String {
        let count = try readStringHeader(code: code)

        // TODO: Optimize iterator
        // let buffer = try read(count: count)
        let data = Array(try read(count: count))

        var string = ""
        var decoder = UTF8()
        var iterator = data.makeIterator()

        decode: for _ in 0..<count {
            switch decoder.decode(&iterator) {
            case .scalarValue(let char): string.unicodeScalars.append(char)
            case .emptyInput: break decode
            case .error: throw Error.invalidData
            }
        }
        return string
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

        let type = try readInt8()
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
        case 0xcc: return try readUInt8()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        switch try readCode() {
        case 0xcd: return try readUInt16()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        switch try readCode() {
        case 0xce: return try readUInt32()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        switch try readCode() {
        case 0xcf: return try readUInt64()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int8.Type) throws -> Int8 {
        let code = try readCode()
        switch code {
        case 0xe0...0xff: return Int8(numericCast(code) - 0x100)
        case 0xd0: return try readInt8()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int16.Type) throws -> Int16 {
        switch try readCode() {
        case 0xd1: return try readInt16()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int32.Type) throws -> Int32 {
        switch try readCode() {
        case 0xd2: return try readInt32()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int64.Type) throws -> Int64 {
        switch try readCode() {
        case 0xd3: return try readInt64()
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
        case 0xd9: return Int(try readUInt8())
        case 0xda: return Int(try readUInt16())
        case 0xdb: return Int(try readUInt32())
        default: throw Error.invalidData
        }
    }

    mutating func readArrayHeader(code: UInt8) throws -> Int {
        switch code {
        case 0x90...0x9f: return Int(code - 0x90)
        case 0xdc: return Int(try readUInt16())
        case 0xdd: return Int(try readUInt32())
        default: throw Error.invalidData
        }
    }

    mutating func readMapHeader(code: UInt8) throws -> Int {
        switch code {
        case 0x80...0x8f: return Int(code - 0x80)
        case 0xde: return Int(try readUInt16())
        case 0xdf: return Int(try readUInt32())
        default: throw Error.invalidData
        }
    }

    mutating func readBinaryHeader(code: UInt8) throws -> Int {
        switch code {
        case 0xc4: return Int(try readUInt8())
        case 0xc5: return Int(try readUInt16())
        case 0xc6: return Int(try readUInt32())
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
        case 0xc7: return Int(try readUInt8())
        case 0xc8: return Int(try readUInt16())
        case 0xc9: return Int(try readUInt32())
        default: throw Error.invalidData
        }
    }
}
