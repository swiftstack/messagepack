public protocol MessagePackInitializable {
    init?(_ value: MessagePack)
}

extension MessagePackInitializable {
    public init?(_ optional: MessagePack?) {
        guard case let .some(value) = optional else {
            return nil
        }
        self.init(value)
    }
}

extension Array where Element: MessagePackInitializable {
    public init?(_ optional: MessagePack?) {
        guard case let .some(value) = optional else {
            return nil
        }
        self.init(value)
    }
}

extension Array where Element: MessagePackInitializable {
    public init?(_ value: MessagePack) {
        guard let items = value.arrayValue else {
            return nil
        }

        var result = [Element]()
        for item in items {
            guard let value = Element(item) else {
                return nil
            }
            result.append(value)
        }
        self = result
    }
}

// Deprecated

extension Bool: MessagePackInitializable {
    @available(*, deprecated, message: "use .booleanValue")
    public init?(_ value: MessagePack) {
        guard case let .bool(value) = value else {
            return nil
        }
        self.init(value)
    }
}

extension String: MessagePackInitializable {
    @available(*, deprecated, message: "use .stringValue")
    public init?(_ value: MessagePack) {
        guard case let .string(string) = value else {
            return nil
        }
        self.init(string)
    }
}

extension Float: MessagePackInitializable {
    @available(*, deprecated, message: "use .floatValue")
    public init?(_ value: MessagePack) {
        switch value {
        case let .float(value): self.init(value)
        default: return nil
        }
    }
}

extension Double: MessagePackInitializable {
    @available(*, deprecated, message: "use .doubleValue")
    public init?(_ value: MessagePack) {
        switch value {
        case let .double(value): self.init(value)
        default: return nil
        }
    }
}

extension Int: MessagePackInitializable {
    @available(*, deprecated, message: "use .integerValue")
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value): self.init(value)
        case let .uint(value) where value <= UInt(Int.max): self.init(value)
        default: return nil
        }
    }
}

extension Int8: MessagePackInitializable {
    @available(*, deprecated, message: "use .integerValue")
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value <= Int(Int8.max): self.init(value)
        case let .uint(value) where value <= UInt(Int8.max): self.init(value)
        default: return nil
        }
    }
}

extension Int16: MessagePackInitializable {
    @available(*, deprecated, message: "use .integerValue")
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value <= Int(Int16.max): self.init(value)
        case let .uint(value) where value <= UInt(Int16.max): self.init(value)
        default: return nil
        }
    }
}

extension Int32: MessagePackInitializable {
    @available(*, deprecated, message: "use .integerValue")
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value <= Int(Int32.max): self.init(value)
        case let .uint(value) where value <= UInt(Int32.max): self.init(value)
        default: return nil
        }
    }
}

extension Int64: MessagePackInitializable {
    @available(*, deprecated, message: "use .integerValue")
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
    @available(*, deprecated, message: "use .unsignedValue")
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value >= 0: self.init(value)
        case let .uint(value): self.init(value)
        default: return nil
        }
    }
}

extension UInt8: MessagePackInitializable {
    @available(*, deprecated, message: "use .unsignedValue")
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
    @available(*, deprecated, message: "use .unsignedValue")
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
    @available(*, deprecated, message: "use .unsignedValue")
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
    @available(*, deprecated, message: "use .unsignedValue")
    public init?(_ value: MessagePack) {
        switch value {
        case let .int(value) where value >= 0: self.init(value)
        case let .uint(value): self.init(value)
        default: return nil
        }
    }
}

extension MessagePack.Extended: MessagePackInitializable {
    @available(*, deprecated, message: "use .extendedValue")
    public init?(_ value: MessagePack) {
        guard case let .extended(data) = value else {
            return nil
        }
        self = data
    }
}

extension Array where Element == UInt8 {
    @available(*, deprecated, message: "use .binaryValue")
    public init?(_ value: MessagePack) {
        guard case let .binary(data) = value else {
            return nil
        }
        self = data
    }
}

extension Array where Element == MessagePack {
    @available(*, deprecated, message: "use .arrayValue")
    public init?(_ value: MessagePack) {
        guard case let .array(items) = value else {
            return nil
        }
        self = items
    }
}

extension Dictionary where Key == MessagePack, Value == MessagePack {
    @available(*, deprecated, message: "use .dictionaryValue")
    public init?(_ value: MessagePack) {
        guard case let .map(items) = value else {
            return nil
        }
        self = items
    }
}

// MARK: Optionals

extension Array where Element == MessagePack {
    @available(*, deprecated, message: "use .arrayValue")
    public init?(_ optional: MessagePack?) {
        guard case let .some(value) = optional else {
            return nil
        }
        self.init(value)
    }
}

extension Dictionary where Key == MessagePack, Value == MessagePack {
    @available(*, deprecated, message: "use .dictionaryValue")
    public init?(_ optional: MessagePack?) {
        guard case let .some(value) = optional else {
            return nil
        }
        self.init(value)
    }
}
