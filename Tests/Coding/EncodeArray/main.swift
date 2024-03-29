import Test
import Stream
import MessagePack

test("EncodeBoolArray") {
    let booleans: [Bool] = [true, false]
    let expected: [UInt8] = [0x92, 0xc3, 0xc2]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: booleans)

    expect(stream.bytes == expected)
}

test("EncodeUIntArray") {
    let bytes: [UInt] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeUInt8Array") {
    let bytes: [UInt8] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeUInt16Array") {
    let bytes: [UInt16] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeUInt32Array") {
    let bytes: [UInt32] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeUInt64Array") {
    let bytes: [UInt64] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeIntArray") {
    let bytes: [Int] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeInt8Array") {
    let bytes: [Int8] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeInt16Array") {
    let bytes: [Int16] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeInt32Array") {
    let bytes: [Int32] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

test("EncodeInt64Array") {
    let bytes: [Int64] = [0x01, 0x02, 0x03]
    let expected: [UInt8] = [0x93, 0x01, 0x02, 0x03]

    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encode(array: bytes)

    expect(stream.bytes == expected)
}

await run()
