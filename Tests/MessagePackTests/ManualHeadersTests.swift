import Test
import MessagePack

class ManualHeadersTests: TestCase {
    func testEncodeArray() {
        let expected = MessagePack.encode(.array(["one", "two", "three"]))
        var writer = MessagePackWriter()
        let items = ["one", "two", "three"]
        writer.encodeArrayItemsCount(items.count)
        for item in items {
            writer.encode(item)
        }
        assertEqual(writer.bytes, expected)
    }

    func testDecodeArray() {
        let expected = ["one", "two", "three"]
        let encoded = MessagePack.encode(.array(["one", "two", "three"]))
        var reader = MessagePackReader(bytes: encoded, count: encoded.count)
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
        let expected = MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        var writer = MessagePackWriter()
        let items = ["one" : 1, "two" : 2, "three" : 3]
        writer.encodeMapItemsCount(items.count)
        for (key, value) in items {
            writer.encode(key)
            writer.encode(value)
        }
        assertEqual(writer.bytes, expected)
    }

    func testDecodeMap() {
        let expected = ["one" : 1, "two" : 2, "three" : 3]
        let encoded = MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        var reader = MessagePackReader(bytes: encoded, count: encoded.count)
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
