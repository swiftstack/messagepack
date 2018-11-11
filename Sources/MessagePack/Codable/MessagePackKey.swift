extension CodingKey {
    var messagePackKey: MessagePack {
        switch intValue {
        case .some(let value): return .int(value)
        case .none: return .string(stringValue)
        }
    }

    init?(_ key: MessagePack) {
        switch key {
        case .int(let value):
            guard let key = Self(intValue: value) else {
                return nil
            }
            self = key
        case .uint(let value) where value < Int.max:
            guard let key = Self(intValue: Int(value)) else {
                return nil
            }
            self = key
        case .string(let value):
            guard let key = Self(stringValue: value) else {
                return nil
            }
            self = key
        default:
            return nil
        }
    }
}

extension MessagePack {
    init(_ key: CodingKey) {
        switch key.intValue {
        case .some(let value): self = .int(value)
        case .none: self = .string(key.stringValue)
        }
    }
}
