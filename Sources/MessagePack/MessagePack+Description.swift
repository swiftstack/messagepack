import Hex

extension MessagePack: CustomStringConvertible {
    public var description: String {
        switch self {
        case .`nil`: return ".nil"
        case let .int(value): return ".int(\(value))"
        case let .uint(value): return ".uint(\(value))"
        case let .bool(value): return ".bool(\(value))"
        case let .float(value): return ".float(\(value))"
        case let .double(value): return ".double(\(value))"
        case let .string(value): return ".string(\"\(value)\")"
        case let .binary(value): return ".binary(\(value.hex))"
        case let .array(value): return ".array(\(value))"
        case let .map(value): return ".map(\(value))"
        case let .extended(value): return ".extended(\(value))"
        }
    }
}

extension MessagePack.Extended: CustomStringConvertible {
    public var description: String {
        return "{\(type), \(data.hex)}"
    }
}

extension Array where Iterator.Element == UInt8 {
    fileprivate var hex: String {
        return String(encodingToHex: self)
    }
}
