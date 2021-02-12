import Stream

public struct MessagePackReader {
    var stream: StreamReader

    typealias Error = MessagePack.Error

    public init(_ stream: StreamReader) {
        self.stream = stream
    }

    mutating func read<T: FixedWidthInteger>(_ type: T.Type) async throws -> T {
        return try await stream.read(type)
    }

    mutating func read(count: Int) async throws -> [UInt8] {
        return try await stream.read(count: count)
    }
}

extension MessagePackReader {
    mutating func readCode() async throws -> UInt8 {
        return try await read(UInt8.self)
    }
}

extension MessagePackReader {
    mutating func readInt(code: UInt8) async throws -> Int {
        switch code {
        case 0xd0: return Int(try await read(Int8.self))
        case 0xd1: return Int(try await read(Int16.self))
        case 0xd2: return Int(try await read(Int32.self))
        case 0xd3: return Int(try await read(Int64.self))
        case 0xe0...0xff: return Int(Int8(numericCast(code) - 0x100))
        default: throw Error.invalidData
        }
    }

    mutating func readUInt(code: UInt8) async throws -> UInt {
        switch code {
        case 0x00...0x7f: return UInt(code)
        case 0xcc: return UInt(try await read(UInt8.self))
        case 0xcd: return UInt(try await read(UInt16.self))
        case 0xce: return UInt(try await read(UInt32.self))
        case 0xcf: return UInt(try await read(UInt64.self))
        default: throw Error.invalidData
        }
    }

    mutating func readBool(code: UInt8) async throws -> Bool {
        switch code {
        case 0xc2: return false
        case 0xc3: return true
        default: throw Error.invalidData
        }
    }

    mutating func readFloat() async throws -> Float {
        let bytes = try await read(UInt32.self)
        return Float(bitPattern: bytes)
    }

    mutating func readDouble() async throws -> Double {
        let bytes = try await read(UInt64.self)
        return Double(bitPattern: bytes)
    }

    mutating func readString(code: UInt8) async throws -> String {
        let count = try await readStringHeader(code: code)
        let bytes = try await read(count: count)
        return String(decoding: bytes, as: UTF8.self)
    }

    mutating func readArray(code: UInt8)async  throws -> [MessagePack] {
        let count = try await readArrayHeader(code: code)
        var array = [MessagePack]()

        array.reserveCapacity(count)
        for _ in 0..<count {
            array.append(try await decode())
        }

        return array
    }

    mutating func readMap(code: UInt8) async throws -> [MessagePack: MessagePack] {
        let count = try await readMapHeader(code: code)
        var dictionary = [MessagePack: MessagePack]()

        for _ in 0..<count {
            let key = try await decode() as MessagePack
            let value = try await decode() as MessagePack
            dictionary[key] = value
        }

        return dictionary
    }

    mutating func readBinary(code: UInt8) async throws -> [UInt8] {
        let count = try await readBinaryHeader(code: code)
        return [UInt8](try await read(count: count))
    }

    mutating func readExtended(code: UInt8) async throws -> MessagePack.Extended {
        let count = try await readExtendedHeader(code: code)

        let type = try await read(Int8.self)
        let data = [UInt8](try await read(count: count))

        return MessagePack.Extended(type: type, data: data)
    }
}

extension MessagePackReader {
    public mutating func decode() async throws -> MessagePack {
        let code = try await readCode()
        switch code {
        // positive fixint
        case 0x00...0x7f: return .uint(try await readUInt(code: code))
        // fixmap
        case 0x80...0x8f: return .map(try await readMap(code: code))
        // fixarray: 8 bit lenght
        case 0x90...0x9f: return .array(try await readArray(code: code))
        // fixstr: 8 bit length
        case 0xa0...0xbf: return .string(try await readString(code: code))
        // nil
        case 0xc0: return .`nil`
        // bool
        case 0xc2...0xc3: return .bool(try await readBool(code: code))
        // bin: 8,16,32 bit length
        case 0xc4...0xc6: return .binary(try await readBinary(code: code))
        // ext 8,16,32 bit length
        case 0xc7...0xc9: return .extended(try await readExtended(code: code))
        // float 32
        case 0xca: return .float(try await readFloat())
        // float 64
        case 0xcb: return .double(try await readDouble())
        // uint 8,16,32,64
        case 0xcc...0xcf: return .uint(try await readUInt(code: code))
        // int 8,16,32,64
        case 0xd0...0xd3: return .int(try await readInt(code: code))
        // fixext 1,2,4,8,16 bytes length
        case 0xd4...0xd8: return .extended(try await readExtended(code: code))
        // str: 8,16,32 bit length
        case 0xd9...0xdb: return .string(try await readString(code: code))
        // array: 16,32 bit length
        case 0xdc...0xdd: return .array(try await readArray(code: code))
        // map: 16,32 bit length
        case 0xde...0xdf: return .map(try await readMap(code: code))
        // negative fixint
        case 0xe0...0xff: return .int(try await readInt(code: code))

        default: throw Error.invalidData
        }
    }

    public mutating func decodeArrayItemsCount() async throws -> Int {
        let code = try await readCode()
        return try await readArrayHeader(code: code)
    }

    public mutating func decodeMapItemsCount() async throws -> Int {
        let code = try await readCode()
        return try await readMapHeader(code: code)
    }

    public mutating func decode(_ type: Int.Type) async throws -> Int {
        let code = try await readCode()
        // positive integers encoded as unsigned
        // since they're used more often,
        // we try to decode and convert it first
        if let unsigned = try? await readUInt(code: code),
            unsigned <= UInt(Int.max) {
            return Int(unsigned)
        }
        return try await readInt(code: code)
    }

    public mutating func decode(_ type: UInt.Type) async throws -> UInt {
        let code = try await readCode()
        return try await readUInt(code: code)
    }

    public mutating func decode(_ type: Bool.Type) async throws -> Bool {
        let code = try await readCode()
        return try await readBool(code: code)
    }

    public mutating func decode(_ type: Float.Type) async throws -> Float {
        switch try await readCode() {
        case 0xca: return try await readFloat()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Double.Type) async throws -> Double {
        switch try await readCode() {
        case 0xcb: return try await readDouble()
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: String.Type) async throws -> String {
        let code = try await readCode()
        switch code {
        case 0xa0...0xbf: fallthrough
        case 0xd9...0xdb: return try await readString(code: code)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt8.Type) async throws -> UInt8 {
        let code = try await readCode()
        switch code {
        case 0x00...0x7f: return code
        case 0xcc: return try await read(UInt8.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt16.Type) async throws -> UInt16 {
        switch try await readCode() {
        case 0xcd: return try await read(UInt16.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt32.Type) async throws -> UInt32 {
        switch try await readCode() {
        case 0xce: return try await read(UInt32.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: UInt64.Type) async throws -> UInt64 {
        switch try await readCode() {
        case 0xcf: return try await read(UInt64.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int8.Type) async throws -> Int8 {
        let code = try await readCode()
        switch code {
        case 0xe0...0xff: return Int8(numericCast(code) - 0x100)
        case 0xd0: return try await read(Int8.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int16.Type) async throws -> Int16 {
        switch try await readCode() {
        case 0xd1: return try await read(Int16.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int32.Type) async throws -> Int32 {
        switch try await readCode() {
        case 0xd2: return try await read(Int32.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: Int64.Type) async throws -> Int64 {
        switch try await readCode() {
        case 0xd3: return try await read(Int64.self)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(_ type: [UInt8].Type) async throws -> [UInt8] {
        let code = try await readCode()
        switch code {
        case 0xc4...0xc6: return try await readBinary(code: code)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(
        _ type: [MessagePack].Type
    ) async throws -> [MessagePack] {
        let code = try await readCode()
        switch code {
        case 0x90...0x9f: fallthrough
        case 0xdc...0xdd: return try await readArray(code: code)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(
        _ type: [MessagePack : MessagePack].Type
    ) async throws -> [MessagePack : MessagePack] {
        let code = try await readCode()
        switch code {
        case 0x80...0x8f: fallthrough
        case 0xde...0xdf: return try await readMap(code: code)
        default: throw Error.invalidData
        }
    }

    public mutating func decode(
        _ type: MessagePack.Extended.Type
    ) async throws -> MessagePack.Extended {
        let code = try await readCode()
        switch code {
        case 0xc7...0xc9: fallthrough
        case 0xd4...0xd8: return try await readExtended(code: code)
        default: throw Error.invalidData
        }
    }
}

// Headers

extension MessagePackReader {
    mutating func readStringHeader(code: UInt8) async throws -> Int {
        switch code {
        case 0xa0...0xbf: return Int(code - 0xa0)
        case 0xd9: return Int(try await read(UInt8.self))
        case 0xda: return Int(try await read(UInt16.self))
        case 0xdb: return Int(try await read(UInt32.self))
        default: throw Error.invalidData
        }
    }

    mutating func readArrayHeader(code: UInt8) async throws -> Int {
        switch code {
        case 0x90...0x9f: return Int(code - 0x90)
        case 0xdc: return Int(try await read(UInt16.self))
        case 0xdd: return Int(try await read(UInt32.self))
        default: throw Error.invalidData
        }
    }

    mutating func readMapHeader(code: UInt8) async throws -> Int {
        switch code {
        case 0x80...0x8f: return Int(code - 0x80)
        case 0xde: return Int(try await read(UInt16.self))
        case 0xdf: return Int(try await read(UInt32.self))
        default: throw Error.invalidData
        }
    }

    mutating func readBinaryHeader(code: UInt8) async throws -> Int {
        switch code {
        case 0xc4: return Int(try await read(UInt8.self))
        case 0xc5: return Int(try await read(UInt16.self))
        case 0xc6: return Int(try await read(UInt32.self))
        default: throw Error.invalidData
        }
    }

    mutating func readExtendedHeader(code: UInt8) async throws -> Int {
        switch code {
        case 0xd4: return 1
        case 0xd5: return 2
        case 0xd6: return 4
        case 0xd7: return 8
        case 0xd8: return 16
        case 0xc7: return Int(try await read(UInt8.self))
        case 0xc8: return Int(try await read(UInt16.self))
        case 0xc9: return Int(try await read(UInt32.self))
        default: throw Error.invalidData
        }
    }
}
