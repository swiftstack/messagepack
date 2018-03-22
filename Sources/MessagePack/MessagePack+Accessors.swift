import Stream

extension MessagePack {

    // MARK: check type

    public var isBoolean: Bool {
        switch self {
        case .bool: return true
        default: return false
        }
    }

    public var isString: Bool {
        switch self {
        case .string: return true
        default: return false
        }
    }

    public var isFloat: Bool {
        switch self {
        case .float: return true
        default: return false
        }
    }

    public var isDouble: Bool {
        switch self {
        case .double: return true
        default: return false
        }
    }

    public var isInteger: Bool {
        switch self {
        case .int: return true
        case .uint: return true
        default: return false
        }
    }

    public var isSigned: Bool {
        switch self {
        case .int: return true
        default: return false
        }
    }

    public var isUnsigned: Bool {
        switch self {
        case .uint: return true
        default: return false
        }
    }

    public var isBinary: Bool {
        switch self {
        case .binary: return true
        default: return false
        }
    }

    public var isArray: Bool {
        switch self {
        case .array: return true
        default: return false
        }
    }

    public var isDictionary: Bool {
        switch self {
        case .map: return true
        default: return false
        }
    }

    public var isExtended: Bool {
        switch self {
        case .extended: return true
        default: return false
        }
    }

    // MARK: unwrap value

    public var booleanValue: Bool? {
        switch self {
        case let .bool(value): return value
        default: return nil
        }
    }

    public var stringValue: String? {
        switch self {
        case let .string(value): return value
        default: return nil
        }
    }

    public var floatValue: Float? {
        switch self {
        case let .float(value): return value
        default: return nil
        }
    }

    public var doubleValue: Double? {
        switch self {
        case let .double(value): return value
        default: return nil
        }
    }

    public var integerValue: Int? {
        switch self {
        case let .int(value): return value
        case let .uint(value) where value <= UInt(Int.max): return Int(value)
        default: return nil
        }
    }

    public var unsignedValue: UInt? {
        switch self {
        case let .int(value) where value >= 0 : return UInt(value)
        case let .uint(value): return value
        default: return nil
        }
    }

    public var binaryValue: [UInt8]? {
        switch self {
        case let .binary(value): return value
        default: return nil
        }
    }

    public var arrayValue: [MessagePack]? {
        switch self {
        case let .array(value): return value
        default: return nil
        }
    }

    public var dictionaryValue: [MessagePack : MessagePack]? {
        switch self {
        case let .map(value): return value
        default: return nil
        }
    }

    public var extendedValue: MessagePack.Extended? {
        switch self {
        case let .extended(value): return value
        default: return nil
        }
    }
}
