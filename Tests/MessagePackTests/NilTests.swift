import Test
import MessagePack

class NilTests: TestCase {
    func testEncodeNil() throws {
        let expected: [UInt8] = [0xc0]
        let encoded = try MessagePack.encode(.nil)
        expect(encoded == expected)
    }

    func testDecodeNil() throws {
        let expected = MessagePack.nil
        let decoded = try MessagePack.decode(bytes: [0xc0])
        expect(decoded == expected)
    }

    func testHasValue() throws {
        let nilValue = MessagePack.nil
        expect(!nilValue.hasValue)
        expect(MessagePack.int(0).hasValue)
        expect(MessagePack.string("").hasValue)
        expect(MessagePack.float(0).hasValue)
        expect(MessagePack.double(0).hasValue)
        expect(MessagePack.array([]).hasValue)
        expect(MessagePack.map([:]).hasValue)
        expect(MessagePack.binary([]).hasValue)
        expect(MessagePack.extended(
            MessagePack.Extended(type: 0, data: [])).hasValue)
    }
}
