import Stream

public class OutputByteStream: OutputStream {
    public var bytes: [UInt8]

    public init(reservingCapacity capacity: Int = 1024) {
        bytes = []
        bytes.reserveCapacity(capacity)
    }

    @inline(__always)
    public func write(_ bytes: UnsafeRawBufferPointer) throws -> Int {
        self.bytes.append(contentsOf: bytes)
        return bytes.count
    }
}

public struct MessagePackWriter<T: OutputStream> {
    public let stream: T

    public init(_ stream: T) {
        self.stream = stream
    }

    mutating func write(_ value: UInt8) throws {
        var value = value
        try withUnsafeBytes(of: &value) { bytes in
            guard try stream.write(bytes) == 1 else {
                throw MessagePackError.streamWriteError
            }
        }
    }

    mutating func write(_ value: UInt16) throws {
        var value = value.byteSwapped
        try withUnsafeBytes(of: &value) { bytes in
            guard try stream.write(bytes) == 2 else {
                throw MessagePackError.streamWriteError
            }
        }
    }

    mutating func write(_ value: UInt32) throws {
        var value = value.byteSwapped
        try withUnsafeBytes(of: &value) { bytes in
            guard try stream.write(bytes) == 4 else {
                throw MessagePackError.streamWriteError
            }
        }
    }

    mutating func write(_ value: UInt64) throws {
        var value = value.byteSwapped
        try withUnsafeBytes(of: &value) { bytes in
            guard try stream.write(bytes) == 8 else {
                throw MessagePackError.streamWriteError
            }
        }
    }

    mutating func write(_ bytes: [UInt8]) throws {
        guard try stream.write(bytes) == bytes.count else {
            throw MessagePackError.streamWriteError
        }
    }
}

extension MessagePackWriter {
    mutating func write(_ value: Int8) throws {
        try write(UInt8(bitPattern: value))
    }

    mutating func write(_ value: Int16) throws {
        try write(UInt16(bitPattern: value))
    }

    mutating func write(_ value: Int32) throws {
        try write(UInt32(bitPattern: value))
    }

    mutating func write(_ value: Int64) throws {
        try write(UInt64(bitPattern: value))
    }
}

extension MessagePackWriter {
    mutating func write(code value: UInt8) throws {
        try write(value)
    }
}
