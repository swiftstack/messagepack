import struct Foundation.Date

public struct Timestamp {
    public var seconds: Int
    public var nanoseconds: Int

    public init(seconds: Int, nanoseconds: Int) {
        self.seconds = seconds
        self.nanoseconds = nanoseconds
    }
}

extension Timestamp: Equatable {
    public static func ==(lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.seconds == rhs.seconds && lhs.nanoseconds == rhs.nanoseconds
    }
}

extension MessagePackReader {
    public mutating func decode(
        _ type: Timestamp.Type
    ) throws -> Timestamp {
        let `extension` = try decode(MessagePack.Extended.self)
        guard `extension`.type == -1 else {
            throw MessagePackError.invalidData
        }

        let data = `extension`.data

        var seconds = 0
        var nanoseconds = 0

        switch data.count {
        case 4:
            // 32 bit
            seconds |= Int(data[0]) << 24
            seconds |= Int(data[1]) << 16
            seconds |= Int(data[2]) << 8
            seconds |= Int(data[3]) << 0
        case 8:
            // 30 bit, drop last 2 bit
            nanoseconds |= Int(data[0]) << 22
            nanoseconds |= Int(data[1]) << 14
            nanoseconds |= Int(data[2]) << 6
            nanoseconds |= Int(data[3]) >> 2
            // 34 bit
            seconds |= Int(data[3] & 0b0000_0011) << 32
            seconds |= Int(data[4]) << 24
            seconds |= Int(data[5]) << 16
            seconds |= Int(data[6]) << 8
            seconds |= Int(data[7]) << 0
        case 12:
            // 32 bit
            nanoseconds |= Int(data[0]) << 24
            nanoseconds |= Int(data[1]) << 16
            nanoseconds |= Int(data[2]) << 8
            nanoseconds |= Int(data[3]) << 0
            // 64 bit
            seconds |= Int(data[4]) << 56
            seconds |= Int(data[5]) << 48
            seconds |= Int(data[6]) << 40
            seconds |= Int(data[7]) << 32
            seconds |= Int(data[8]) << 24
            seconds |= Int(data[9]) << 16
            seconds |= Int(data[10]) << 8
            seconds |= Int(data[11]) << 0
        default:
            throw MessagePackError.invalidData
        }

        return Timestamp(seconds: seconds, nanoseconds: nanoseconds)
    }

    public mutating func decode(
        _ type: Date.Type
    ) throws -> Date {
        let timestamp = try decode(Timestamp.self)
        let timeInterval = Double(timestamp.seconds) +
            Double(timestamp.nanoseconds) / 1_000_000_000
        return Date(timeIntervalSince1970: timeInterval)
    }
}

extension MessagePackWriter {
    public mutating func encode(_ timestamp: Timestamp) throws {
        var `extension` = MessagePack.Extended(type: -1, data: [])

        if timestamp.seconds >> 34 == 0 {
            if timestamp.nanoseconds == 0 && timestamp.seconds <= UInt32.max {
                var data = [UInt8](repeating: 0, count: 4)
                data[0] = UInt8(truncatingIfNeeded: timestamp.seconds >> 24)
                data[1] = UInt8(truncatingIfNeeded: timestamp.seconds >> 16)
                data[2] = UInt8(truncatingIfNeeded: timestamp.seconds >> 8)
                data[3] = UInt8(truncatingIfNeeded: timestamp.seconds >> 0)
                `extension`.data = data
            } else {
                guard timestamp.nanoseconds & ~0x3fff_ffff == 0,
                    timestamp.seconds & ~0x0003_ffff_ffff == 0 else {
                        throw MessagePackError.invalidData
                }
                var data = [UInt8](repeating: 0, count: 8)

                data[0] = UInt8(truncatingIfNeeded: timestamp.nanoseconds >> 22)
                data[1] = UInt8(truncatingIfNeeded: timestamp.nanoseconds >> 14)
                data[2] = UInt8(truncatingIfNeeded: timestamp.nanoseconds >> 6)
                data[3] = UInt8(truncatingIfNeeded: timestamp.nanoseconds << 2)

                data[3] |= UInt8(truncatingIfNeeded: timestamp.seconds >> 32)
                data[4] = UInt8(truncatingIfNeeded: timestamp.seconds >> 24)
                data[5] = UInt8(truncatingIfNeeded: timestamp.seconds >> 16)
                data[6] = UInt8(truncatingIfNeeded: timestamp.seconds >> 8)
                data[7] = UInt8(truncatingIfNeeded: timestamp.seconds >> 0)

                `extension`.data = data
            }
        } else {
            guard timestamp.nanoseconds <= UInt32.max else {
                throw MessagePackError.invalidData
            }
            var data = [UInt8](repeating: 0, count: 12)

            data[0] = UInt8(truncatingIfNeeded: timestamp.nanoseconds >> 24)
            data[1] = UInt8(truncatingIfNeeded: timestamp.nanoseconds >> 16)
            data[2] = UInt8(truncatingIfNeeded: timestamp.nanoseconds >> 8)
            data[3] = UInt8(truncatingIfNeeded: timestamp.nanoseconds >> 0)

            data[4] = UInt8(truncatingIfNeeded: timestamp.seconds >> 56)
            data[5] = UInt8(truncatingIfNeeded: timestamp.seconds >> 48)
            data[6] = UInt8(truncatingIfNeeded: timestamp.seconds >> 40)
            data[7] = UInt8(truncatingIfNeeded: timestamp.seconds >> 32)
            data[8] = UInt8(truncatingIfNeeded: timestamp.seconds >> 24)
            data[9] = UInt8(truncatingIfNeeded: timestamp.seconds >> 16)
            data[10] = UInt8(truncatingIfNeeded: timestamp.seconds >> 8)
            data[11] = UInt8(truncatingIfNeeded: timestamp.seconds >> 0)

            `extension`.data = data
        }
        try encode(`extension`)
    }

    public mutating func encode(_ date: Date) throws {
        let timeInterval = date.timeIntervalSince1970
        let seconds = Int(timeInterval)
        let nanoseconds = Int(
            timeInterval.truncatingRemainder(dividingBy: 1) * 1_000_000_000)
        try encode(Timestamp(seconds: seconds, nanoseconds: nanoseconds))
    }
}
