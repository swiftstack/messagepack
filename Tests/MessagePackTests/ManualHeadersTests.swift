import Test
import Stream
import MessagePack

class ManualHeadersTests: TestCase {
    func testEncodeArray() throws {
        let expected = try MessagePack.encode(
            .array(["one", "two", "three"]))
        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        let items = ["one", "two", "three"]
        try writer.encodeArrayItemsCount(items.count)
        for item in items {
            try writer.encode(item)
        }
        expect(stream.bytes == expected)
    }

    func testDecodeArray() throws {
        let expected = ["one", "two", "three"]
        let encoded = try MessagePack.encode(
            .array(["one", "two", "three"]))
        var reader = MessagePackReader(InputByteStream(encoded))
        var result = [String]()
        let itemsCount = try reader.decodeArrayItemsCount()
        for _ in 0..<itemsCount {
            result.append(try reader.decode(String.self))
        }
        expect(result == expected)
    }

    func testEncodeMap() throws {
        let items: [MessagePack : MessagePack] =
            ["one" : 1, "two" : 2, "three" : 3]
        let expected = try MessagePack.encode(.map(items))
        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        try writer.encodeMapItemsCount(items.count)
        for (key, value) in items {
            try writer.encode(key)
            try writer.encode(value)
        }
        expect(stream.bytes == expected)
    }

    func testDecodeMap() throws {
        let expected = ["one" : 1, "two" : 2, "three" : 3]
        let encoded = try MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        var reader = MessagePackReader(InputByteStream(encoded))
        var result = [String : Int]()
        let itemsCount = try reader.decodeMapItemsCount()
        for _ in 0..<itemsCount {
            let key = try reader.decode(String.self)
            let value = try reader.decode(Int.self)
            result[key] = value
        }
        expect(result == expected)
    }
}
