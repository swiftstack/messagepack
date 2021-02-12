import Test
import Stream
@testable import MessagePack

test.case("StringHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    expect(throws: MessagePack.Error.invalidData) {
        try await reader.readStringHeader(code: reader.readCode())
    }
}

test.case("ArrayHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    expect(throws: MessagePack.Error.invalidData) {
        try await reader.readArrayHeader(code: reader.readCode())
    }
}

test.case("MapHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    expect(throws: MessagePack.Error.invalidData) {
        try await reader.readMapHeader(code: reader.readCode())
    }
}

test.case("BinaryHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    expect(throws: MessagePack.Error.invalidData) {
        try await reader.readBinaryHeader(code: reader.readCode())
    }
}

test.case("ExtendedHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    expect(throws: MessagePack.Error.invalidData) {
        try await reader.readExtendedHeader(code: reader.readCode())
    }
}

test.run()
