extension MessagePack {
    public var isNil: Bool {
        switch self {
        case .nil: return true
        default: return false
        }
    }

    public var array: [MessagePack]? {
        switch self {
        case .array(let array): return array
        default: return nil
        }
    }

    public var map: [MessagePack: MessagePack]? {
        switch self {
        case .map(let dictionary): return dictionary
        default: return nil
        }
    }

    public var binary: [UInt8]? {
        switch self {
        case .binary(let bytes): return bytes
        default: return nil
        }
    }

    public var extended: MessagePack.Extended? {
        switch self {
        case .extended(let value): return value
        default: return nil
        }
    }
}
