// TODO: rename the file to Encoder+Error.swift for the next Swift release

extension Encoder {
    public enum Error: Swift.Error {
        public enum ContainerType {
            case keyed(by: CodingKey.Type, for: CodingKey?)
            case unkeyed(for: CodingKey?)
            case singleValue
        }

        case containerTypeMismatch(
            requested: ContainerType,
            actual: Any)
    }
}

// MARK: Convenience

extension Encoder.Error.ContainerType {
    static func keyed(by type: CodingKey.Type) -> Encoder.Error.ContainerType {
        return .keyed(by: type, for: nil)
    }

    static var unkeyed: Encoder.Error.ContainerType {
        return .unkeyed(for: nil)
    }
}

// FIXME: ha-ha gotcha!
import struct Codable.EncodingError
import struct Codable.KeyedEncodingError

extension EncodingError {
    // return EncodingError(.containerTypeMismatch)
    // vs
    // return EncodingError(Error.containerTypeMismatch)
    init(_ error: Encoder.Error) {
        self.init(error as Swift.Error)
    }
}

extension KeyedEncodingError {
    // return KeyedEncodingError(.containerTypeMismatch)
    // vs
    // return KeyedEncodingError(Error.containerTypeMismatch)
    init(_ error: Encoder.Error) {
        self.init(error as Swift.Error)
    }
}
