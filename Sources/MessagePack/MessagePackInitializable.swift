public protocol MessagePackInitializable {
    init?(_ value: MessagePack)
}

extension Bool: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        guard case let .bool(value) = value else {
            return nil
        }
        self.init(value)
    }
}

extension String: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        guard case let .string(string) = value else {
            return nil
        }
        self.init(string)
    }
}

extension Float: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .float(value): self.init(value)
        default: return nil
        }
    }
}

extension Double: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .double(value): self.init(value)
        default: return nil
        }
    }
}

extension Int: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value): self.init(value)
        case let .uint(value) where value <= UInt(Int.max): self.init(value)
        default: return nil
        }
    }
}

extension Int8: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value <= Int(Int8.max): self.init(value)
        case let .uint(value) where value <= UInt(Int8.max): self.init(value)
        default: return nil
        }
    }
}

extension Int16: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value <= Int(Int16.max): self.init(value)
        case let .uint(value) where value <= UInt(Int16.max): self.init(value)
        default: return nil
        }
    }
}

extension Int32: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value <= Int(Int32.max): self.init(value)
        case let .uint(value) where value <= UInt(Int32.max): self.init(value)
        default: return nil
        }
    }
}

extension Int64: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value):
            self.init(value)
        case let .uint(value) where UInt64(value) <= UInt64(Int64.max):
            self.init(value)
        default: return nil
        }
    }
}

extension UInt: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value >= 0 : self.init(value)
        case let .uint(value): self.init(value)
        default: return nil
        }
    }
}

extension UInt8: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value >= 0 && UInt(value) <= UInt(UInt8.max):
            self.init(value)
        case let .uint(value) where value <= UInt(UInt8.max):
            self.init(value)
        default: return nil
        }
    }
}

extension UInt16: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value)
            where value >= 0 && UInt(value) <= UInt(UInt16.max):
            self.init(value)
        case let .uint(value)
            where value <= UInt(UInt16.max):
            self.init(value)
        default: return nil
        }
    }
}

extension UInt32: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value)
            where value >= 0 && UInt(value) <= UInt(UInt32.max):
            self.init(value)
        case let .uint(value)
            where value <= UInt(UInt32.max):
            self.init(value)
        default: return nil
        }
    }
}

extension UInt64: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value >= 0: self.init(value)
        case let .uint(value): self.init(value)
        default: return nil
        }
    }
}

extension MessagePack.Extended: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        guard case let .extended(data) = value else {
            return nil
        }
        self = data
    }
}


extension Array where Element == UInt8 {
    public init?(_ value: MessagePack) {
        guard case let .binary(data) = value else {
            return nil
        }
        self = data
    }
}

extension Array where Element == MessagePack {
    public init?(_ value: MessagePack) {
        guard case let .array(items) = value else {
            return nil
        }
        self = items
    }
}

extension Dictionary where Key == MessagePack, Value == MessagePack {
    public init?(_ value: MessagePack) {
        guard case let .map(items) = value else {
            return nil
        }
        self = items
    }
}

extension Array where Element: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        guard let array = [MessagePack](value) else {
            return nil
        }

        var result = [Element]()
        for item in array {
            guard let value = Element(item) else {
                return nil
            }
            result.append(value)
        }
        self = result
    }
}

// MARK: Optionals

extension MessagePackInitializable {
    public init?(_ optional: MessagePack?) {
        guard case let .some(value) = optional,
            let result = Self(value) else {
                return nil
        }
        self = result
    }
}

extension Array where Element == MessagePack {
    public init?(_ optional: MessagePack?) {
        guard case let .some(value) = optional,
            let result = Array(value) else {
                return nil
        }
        self = result
    }
}

extension Dictionary where Key == MessagePack, Value == MessagePack {
    public init?(_ optional: MessagePack?) {
        guard case let .some(value) = optional,
            let result = Dictionary(value) else {
                return nil
        }
        self = result
    }
}

extension Array where Element: MessagePackInitializable {
    public init?(_ optional: MessagePack?) {
        guard case let .some(value) = optional,
            let result = Array(value) else {
                return nil
        }
        self = result
    }
}
