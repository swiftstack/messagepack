public enum MessagePack: Equatable, Hashable {
    case `nil`
    case int(Int)
    case uint(UInt)
    case bool(Bool)
    case float(Float)
    case double(Double)
    case string(String)
    case binary([UInt8])
    case array([MessagePack])
    case map([MessagePack : MessagePack])
    case extended(Extended)

    public struct Extended: Equatable, Hashable {
        public var type: Int8
        public var data: [UInt8]

        public init(type: Int8, data: [UInt8]) {
            self.type = type
            self.data = data
        }
    }
}

extension MessagePack {
    public var hasValue: Bool {
        switch self {
        case .nil: return false
        default: return true
        }
    }
}

extension MessagePack: CustomStringConvertible {
    public var description: String {
        switch self {
        case .`nil`: return "nil"
        case let .int(value): return value.description
        case let .uint(value): return value.description
        case let .bool(value): return value.description
        case let .float(value): return value.description
        case let .double(value): return value.description
        case let .string(string): return "\"\(string)\""
        case let .binary(data): return data.hexDescription
        case let .array(array): return array.description
        case let .map(dict): return dict.description
        case let .extended(extended): return extended.description
        }
    }
}

extension MessagePack.Extended: CustomStringConvertible {
    public var description: String {
        return "{\(type), \(data.hexDescription)}"
    }
}
