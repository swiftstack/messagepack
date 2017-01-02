extension MessagePack: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .nil
    }
}

extension MessagePack: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension MessagePack: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension MessagePack: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension MessagePack: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension MessagePack: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: String) {
        self = .string(value)
    }
}

extension MessagePack: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .string(value)
    }
}

extension MessagePack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: MessagePack...) {
        self = .array(elements)
    }
}

extension MessagePack: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (MessagePack, MessagePack)...) {
        var dictionary = [MessagePack: MessagePack](minimumCapacity: elements.count)
        for (key, value) in elements {
            dictionary[key] = value
        }
        self = .map(dictionary)
    }
}
