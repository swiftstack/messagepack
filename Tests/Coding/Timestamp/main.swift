import Test
import Stream
import MessagePack

test.case("Encode4") {
    let expected: [UInt8] = [
        0xd6, UInt8(bitPattern: -1),
        0x00, 0x00, 0x00, 0x01]

    let timestamp = Timestamp(seconds: 1, nanoseconds: 0)

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(timestamp)
    expect(stream.bytes == expected)
}

test.case("Encode8") {
    let expected: [UInt8] = [
        0xd7, UInt8(bitPattern: -1),
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff]

    let timestamp = Timestamp(
        seconds: 0x0003_ffff_ffff,
        nanoseconds: 0x3fff_ffff)

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(timestamp)
    expect(stream.bytes == expected)
}

test.case("Encode12") {
    let expected: [UInt8] = [
        0xc7, 12, UInt8(bitPattern: -1),
        0x00, 0x00, 0x00, 0x01,
        0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]

    let timestamp = Timestamp(seconds: Int.max, nanoseconds: 1)

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(timestamp)
    expect(stream.bytes == expected)
}

test.case("Decode4") {
    let expected = Timestamp(seconds: 1, nanoseconds: 0)

    let encoded: [UInt8] = [
        0xd6, UInt8(bitPattern: -1),
        0x00, 0x00, 0x00, 0x01]

    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Timestamp.self)
    expect(decoded == expected)
}

test.case("Decode8") {
    let expected = Timestamp(
        seconds: 0x0003_ffff_ffff,
        nanoseconds: 0x3fff_ffff)

    let encoded: [UInt8] = [
        0xd7, UInt8(bitPattern: -1),
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff]

    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Timestamp.self)
    expect(decoded == expected)
}

test.case("Decode12") {
    let expected = Timestamp(seconds: 1, nanoseconds: 1)

    let encoded: [UInt8] = [
        0xc7, 12, UInt8(bitPattern: -1),
        0x00, 0x00, 0x00, 0x01,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]

    var reader = MessagePackReader(InputByteStream(encoded))
    let decoded = try await reader.decode(Timestamp.self)
    expect(decoded == expected)
}

test.run()
