extension CodingKey {
    init?(_ key: MessagePack) {
        switch key {
        case .int(let value):
            self.init(intValue: value)
        case .uint(let value) where value < Int.max:
            self.init(intValue: Int(value))
        case .string(let value):
            self.init(stringValue: value)
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

extension Dictionary where Key == MessagePack {
    subscript(_ key: CodingKey) -> Value? {
        return self[MessagePack(key)]
    }
}
