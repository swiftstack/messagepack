import Foundation

extension Sequence where Iterator.Element == UInt8 {
    var hexDescription: String {
        var bytes: [String] = []
        for byte in self {
            let prefix = byte < 16 ? "0x0" : "0x"
            bytes.append(prefix + String(byte, radix: 16))
        }
        let joined = bytes.joined(separator: ", ")
        return "[\(joined)]"
    }
}
