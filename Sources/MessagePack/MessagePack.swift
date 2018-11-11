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
