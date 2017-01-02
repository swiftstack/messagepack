public enum MessagePack {
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

    public struct Extended {
        public let type: Int8
        public let data: [UInt8]
        public init(type: Int8, data: [UInt8]) {
            self.type = type
            self.data = data
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
        case let .extended(extended): return "{\(extended.type), \(extended.data.hexDescription)}"
        }
    }
}

extension MessagePack.Extended: Hashable {
    public var hashValue: Int {
        return type.hashValue ^ data.hashValue
    }
}
extension MessagePack: Hashable {
    public var hashValue: Int {
        switch self {
        case .`nil`: return 0
        case .int(let value): return value.hashValue
        case .uint(let value): return value.hashValue
        case .bool(let value): return value.hashValue
        case .float(let value): return value.hashValue
        case .double(let value): return value.hashValue
        case .string(let string): return string.hashValue
        case .binary(let bytes): return bytes.hashValue
        case .array(let items): return items.reduce(items.count.hashValue) { $0 ^ $1.hashValue }
        case .map(let items): return items.reduce(items.count.hashValue) { $0 ^ $1.key.hashValue ^ $1.value.hashValue }
        case .extended(let value): return value.hashValue
        }
    }
}

extension MessagePack.Extended: Equatable {}
public func ==(lhs: MessagePack.Extended, rhs: MessagePack.Extended) -> Bool {
    return lhs.type == rhs.type && lhs.data == rhs.data
}

extension MessagePack: Equatable {}
public func ==(lhs: MessagePack, rhs: MessagePack) -> Bool {
    switch (lhs, rhs) {
    case (.`nil`, .`nil`): return true
    case let (.int(lhv), .int(rhv)): return lhv == rhv
    case let (.int(lhv), .uint(rhv)): return lhv >= 0 && UInt(lhv) == rhv
    case let (.uint(lhv), .uint(rhv)): return lhv == rhv
    case let (.uint(lhv), .int(rhv)): return rhv >= 0 && lhv == UInt(rhv)
    case let (.bool(lhv), .bool(rhv)): return lhv == rhv
    case let (.float(lhv), .float(rhv)): return lhv == rhv
    case let (.double(lhv), .double(rhv)): return lhv == rhv
    case let (.string(lhv), .string(rhv)): return lhv == rhv
    case let (.binary(lhv), .binary(rhv)): return lhv == rhv
    case let (.array(lhv), .array(rhv)): return lhv == rhv
    case let (.map(lhv), .map(rhv)): return lhv == rhv
    case let (.extended(lhv), .extended(rhv)): return lhv == rhv
    default: return false
    }
}
