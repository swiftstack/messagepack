import Test
import Stream
@testable import MessagePack

test("StringHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    await expect(throws: MessagePack.Error.invalidData) {
        try await reader.readStringHeader(code: reader.readCode())
    }
}

test("ArrayHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    await expect(throws: MessagePack.Error.invalidData) {
        try await reader.readArrayHeader(code: reader.readCode())
    }
}

test("MapHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    await expect(throws: MessagePack.Error.invalidData) {
        try await reader.readMapHeader(code: reader.readCode())
    }
}

test("BinaryHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    await expect(throws: MessagePack.Error.invalidData) {
        try await reader.readBinaryHeader(code: reader.readCode())
    }
}

test("ExtendedHeader") {
    let header: [UInt8] = [0xff]
    var reader = MessagePackReader(InputByteStream(header))
    await expect(throws: MessagePack.Error.invalidData) {
        try await reader.readExtendedHeader(code: reader.readCode())
    }
}

await run()
