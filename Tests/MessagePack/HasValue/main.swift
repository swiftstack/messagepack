import Test
import MessagePack

test("HasValue") {
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

await run()
