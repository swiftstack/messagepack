public struct Encoder {
    public var bytes = [UInt8]()

    public init(reservingCapacity capacity: Int = 1024) {
        bytes.reserveCapacity(capacity)
    }

    public mutating func removeAll() {
        bytes.removeAll(keepingCapacity: true)
    }

    mutating func write(_ value: UInt8) {
        bytes.append(value)
    }

    mutating func write(_ value: UInt16) {
        bytes.append(UInt8(truncatingIfNeeded: value >> 8))
        bytes.append(UInt8(truncatingIfNeeded: value))
    }

    mutating func write(_ value: UInt32) {
        bytes.append(UInt8(truncatingIfNeeded: value >> 24))
        bytes.append(UInt8(truncatingIfNeeded: value >> 16))
        bytes.append(UInt8(truncatingIfNeeded: value >> 8))
        bytes.append(UInt8(truncatingIfNeeded: value))
    }

    mutating func write(_ value: UInt64) {
        bytes.append(UInt8(truncatingIfNeeded: value >> 56))
        bytes.append(UInt8(truncatingIfNeeded: value >> 48))
        bytes.append(UInt8(truncatingIfNeeded: value >> 40))
        bytes.append(UInt8(truncatingIfNeeded: value >> 32))
        bytes.append(UInt8(truncatingIfNeeded: value >> 24))
        bytes.append(UInt8(truncatingIfNeeded: value >> 16))
        bytes.append(UInt8(truncatingIfNeeded: value >> 8))
        bytes.append(UInt8(truncatingIfNeeded: value))
    }

    mutating func write(_ bytes: [UInt8]) {
        self.bytes.append(contentsOf: bytes)
    }
}

extension Encoder {
    mutating func write(_ value: Int8) {
        write(UInt8(bitPattern: value))
    }

    mutating func write(_ value: Int16) {
        write(UInt16(bitPattern: value))
    }

    mutating func write(_ value: Int32) {
        write(UInt32(bitPattern: value))
    }

    mutating func write(_ value: Int64) {
        write(UInt64(bitPattern: value))
    }
}

extension Encoder {
    mutating func write(code value: UInt8) {
        write(value)
    }
}
