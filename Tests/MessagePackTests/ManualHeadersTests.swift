import Test
import Stream
import MessagePack

class ManualHeadersTests: TestCase {
    func testEncodeArray() {
        let expected = try! MessagePack.encode(.array(["one", "two", "three"]))
        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        let items = ["one", "two", "three"]
        try? writer.encodeArrayItemsCount(items.count)
        for item in items {
            try? writer.encode(item)
        }
        assertEqual(stream.bytes, expected)
    }

    func testDecodeArray() {
        let expected = ["one", "two", "three"]
        let encoded = try? MessagePack.encode(.array(["one", "two", "three"]))
        var reader = MessagePackReader(InputByteStream(encoded ?? []))
        var result = [String]()
        do {
            let itemsCount = try reader.decodeArrayItemsCount()
            for _ in 0..<itemsCount {
                result.append(try reader.decode(String.self))
            }
        } catch {
            fail(String(describing: error))
            return
        }
        assertEqual(result, expected)
    }

    func testEncodeMap() {
        let expected = try! MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        let stream = OutputByteStream()
        var writer = MessagePackWriter(stream)
        let items = ["one" : 1, "two" : 2, "three" : 3]
        try? writer.encodeMapItemsCount(items.count)
        for (key, value) in items {
            try? writer.encode(key)
            try? writer.encode(value)
        }
        assertEqual(stream.bytes, expected)
    }

    func testDecodeMap() {
        let expected = ["one" : 1, "two" : 2, "three" : 3]
        let encoded = try? MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        var reader = MessagePackReader(InputByteStream(encoded ?? []))
        var result = [String : Int]()
        do {
            let itemsCount = try reader.decodeMapItemsCount()
            for _ in 0..<itemsCount {
                let key = try reader.decode(String.self)
                let value = try reader.decode(Int.self)
                result[key] = value
            }
        } catch {
            fail(String(describing: error))
            return
        }
        assertEqual(result, expected)
    }
}
