import Test
import Stream
import MessagePack

test("ByteStream") {
    let expected: MessagePack = [1,2,3]
    let bytes: [UInt8] = [0x93, 0x01, 0x02, 0x03]
    var reader = MessagePackReader(InputByteStream(bytes))
    let decoded = try await reader.decode() as MessagePack
    expect(decoded == expected)
}

await run()
