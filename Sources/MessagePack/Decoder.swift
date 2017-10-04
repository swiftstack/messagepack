import Stream

public class InputByteStream: InputStream {
    public let bytes: [UInt8]
    public var index = 0

    public init(_ bytes: [UInt8]) {
        self.bytes = bytes
    }

    @inline(__always)
    public func read(to buffer: UnsafeMutableRawBufferPointer) throws -> Int {
        guard index + buffer.count <= bytes.count else {
            throw MessagePackError.insufficientData
        }
        buffer.copyBytes(from: bytes[index..<index+buffer.count])
        index += buffer.count
        return buffer.count
    }
}

public struct MessagePackReader<T: InputStream> {
    let stream: T

    public init(_ stream: T) {
        self.stream = stream
    }

    mutating func readUInt8() throws -> UInt8 {
        var result: UInt8 = 0
        guard try stream.read(to: &result, count: 1) == 1 else {
            throw MessagePackError.insufficientData
        }
        return result
    }

    mutating func readUInt16() throws -> UInt16 {
        var result: UInt16 = 0
        guard try stream.read(to: &result, count: 2) == 2 else {
            throw MessagePackError.insufficientData
        }
        return result.byteSwapped
    }

    mutating func readUInt32() throws -> UInt32 {
        var result: UInt32 = 0
        guard try stream.read(to: &result, count: 4) == 4 else {
            throw MessagePackError.insufficientData
        }
        return result.byteSwapped
    }

    mutating func readUInt64() throws -> UInt64 {
        var result: UInt64 = 0
        guard try stream.read(to: &result, count: 8) == 8 else {
            throw MessagePackError.insufficientData
        }
        return result.byteSwapped
    }

    mutating func read(count: Int) throws -> [UInt8] {
        var result = [UInt8](repeating: 0, count: count)
        guard try stream.read(to: &result) == count else {
            throw MessagePackError.insufficientData
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
        default: throw MessagePackError.invalidData
        }
    }

    mutating func readUInt(code: UInt8) throws -> UInt {
        switch code {
        case 0x00...0x7f: return UInt(code)
        case 0xcc: return UInt(try readUInt8())
        case 0xcd: return UInt(try readUInt16())
        case 0xce: return UInt(try readUInt32())
        case 0xcf: return UInt(try readUInt64())
        default: throw MessagePackError.invalidData
        }
    }

    mutating func readBool(code: UInt8) throws -> Bool {
        switch code {
        case 0xc2: return false
        case 0xc3: return true
        default: throw MessagePackError.invalidData
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
            case .error: throw MessagePackError.invalidData
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
