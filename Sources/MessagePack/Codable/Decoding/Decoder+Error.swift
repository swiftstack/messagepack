extension Decoder {
    enum Error: Swift.Error {
        enum ContainerType {
            case keyed(by: CodingKey.Type, for: CodingKey?)
            case unkeyed(for: CodingKey?)
            case singleValue
        }

        case containerTypeMismatch(
            requested: ContainerType,
            actual: Any)

        case typeMismatch(
            forKey: CodingKey?,
            requested: Decodable.Type,
            actual: Any)

        case keyNotFound(CodingKey)
    }
}

extension Decoder.Error {
    static func typeMismatch(
        requested: Decodable.Type,
        actual: Any) -> Decoder.Error
    {
        return .typeMismatch(
            forKey: nil,
            requested: requested,
            actual: actual)
    }
}

extension Decoder.Error.ContainerType {
    static func keyed(by type: CodingKey.Type) -> Decoder.Error.ContainerType {
        return .keyed(by: type, for: nil)
    }

    static var unkeyed: Decoder.Error.ContainerType {
        return .unkeyed(for: nil)
    }
}
