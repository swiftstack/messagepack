import Test
import Stream
import MessagePack

test("EncodeArray") {
    let expected = try await MessagePack.encode(
        .array(["one", "two", "three"]))
    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    let items = ["one", "two", "three"]
    try await writer.encodeArrayItemsCount(items.count)
    for item in items {
        try await writer.encode(item)
    }
    expect(stream.bytes == expected)
}

test("DecodeArray") {
    let expected = ["one", "two", "three"]
    let encoded = try await MessagePack.encode(
        .array(["one", "two", "three"]))
    var reader = MessagePackReader(InputByteStream(encoded))
    var result = [String]()
    let itemsCount = try await reader.decodeArrayItemsCount()
    for _ in 0..<itemsCount {
        result.append(try await reader.decode(String.self))
    }
    expect(result == expected)
}

test("EncodeMap") {
    let items: [MessagePack: MessagePack] =
        ["one": 1, "two": 2, "three": 3]
    let expected = try await MessagePack.encode(.map(items))
    let stream = OutputByteStream()
    var writer = MessagePackWriter(stream)
    try await writer.encodeMapItemsCount(items.count)
    for (key, value) in items {
        try await writer.encode(key)
        try await writer.encode(value)
    }
    expect(stream.bytes == expected)
}

test("DecodeMap") {
    let expected = ["one": 1, "two": 2, "three": 3]
    let encoded = try await MessagePack.encode(
        .map(["one": 1, "two": 2, "three": 3]))
    var reader = MessagePackReader(InputByteStream(encoded))
    var result = [String: Int]()
    let itemsCount = try await reader.decodeMapItemsCount()
    for _ in 0..<itemsCount {
        let key = try await reader.decode(String.self)
        let value = try await reader.decode(Int.self)
        result[key] = value
    }
    expect(result == expected)
}

await run()
