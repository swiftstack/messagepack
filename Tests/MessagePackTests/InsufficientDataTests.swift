import Test
import MessagePack

class InsufficientDataTests: TestCase {
    func testInvalidData() {
        let bytes: [UInt8] = [0xc1]
        do {
            _ = try MessagePack.decode(bytes: bytes)
            fail("Expected deserializer to throw")
        } catch {
            assertEqual(error as? MessagePack.Error, .invalidData)
        }
    }

    func testIntegerInsufficientData() {
        let testCollection: [[UInt8]] = [
            [0xd0], [0xd1], [0xd2], [0xd3],
            [0xcc], [0xcd], [0xde], [0xdf]
        ]
        for bytes in testCollection {
            do {
                _ = try MessagePack.decode(bytes: bytes)
                fail("Expected deserializer to throw")
            } catch {
                assertEqual(error as? MessagePack.Error, .insufficientData)
            }
        }
    }

    func testFloatInsufficientData() {
        let testCollection: [[UInt8]] = [
            [0xca], [0xcb]
        ]
        for bytes in testCollection {
            do {
                _ = try MessagePack.decode(bytes: bytes)
                fail("Expected deserializer to throw")
            } catch {
                assertEqual(error as? MessagePack.Error, .insufficientData)
            }
        }
    }

    func testStringInsufficientData() {
        let testCollection: [[UInt8]] = [
            // fixstr
            [0xa1], [0xa2], [0xa3], [0xa4], [0xa5], [0xa6], [0xa7],
            [0xa8], [0xa9], [0xaa], [0xab], [0xac], [0xad], [0xae], [0xaf],
            [0xb0], [0xb1], [0xb2], [0xb3], [0xb4], [0xb5], [0xb6], [0xb7],
            [0xb8], [0xb9], [0xba], [0xbb], [0xbc], [0xbd], [0xbe], [0xbf],
            // str 8,16,32
            [0xd9, 0x01],
            [0xda, 0x00, 0x01],
            [0xdb, 0x00, 0x00, 0x00, 0x01]
        ]
        for bytes in testCollection {
            do {
                _ = try MessagePack.decode(bytes: bytes)
                fail("Expected deserializer to throw")
            } catch {
                assertEqual(error as? MessagePack.Error, .insufficientData)
            }
        }
    }

    func testArrayInsufficientData() {
        let testCollection: [[UInt8]] = [
            // fixarr
            [0x91], [0x92], [0x93], [0x94], [0x95], [0x96], [0x97],
            [0x98], [0x99], [0x9a], [0x9b], [0x9c], [0x9d], [0x9e], [0x9f],
            // arr 16,32
            [0xdc, 0x00, 0x01],
            [0xdd, 0x00, 0x00, 0x00, 0x01]
        ]
        for bytes in testCollection {
            do {
                _ = try MessagePack.decode(bytes: bytes)
                fail("Expected deserializer to throw")
            } catch {
                assertEqual(error as? MessagePack.Error, .insufficientData)
            }
        }
    }

    func testMapInsufficientData() {
        let testCollection: [[UInt8]] = [
            // no data
            [0x81], [0x82], [0x83], [0x84], [0x85], [0x86], [0x87],
            [0x88], [0x89], [0x8a], [0x8b], [0x8c], [0x8d], [0x8e], [0x8f],
            // no size, no data
            [0xde, 0x00, 0x01],
            [0xdf, 0x00, 0x00, 0x00, 0x01]
        ]
        for bytes in testCollection {
            do {
                _ = try MessagePack.decode(bytes: bytes)
                fail("Expected deserializer to throw")
            } catch {
                assertEqual(error as? MessagePack.Error, .insufficientData)
            }
        }
    }

    func testBinaryInsufficientData() {
        let testCollection: [[UInt8]] = [
            // no size, no data
            [0xc4], [0xc5], [0xc6],
            // no data
            [0xc4, 0x01],
            [0xc5, 0x00, 0x01],
            [0xc6, 0x00, 0x00, 0x00, 0x01]
        ]
        for bytes in testCollection {
            do {
                _ = try MessagePack.decode(bytes: bytes)
                fail("Expected deserializer to throw")
            } catch {
                assertEqual(error as? MessagePack.Error, .insufficientData)
            }
        }
    }

    func testExtendedInsufficientData() {
        let testCollection: [[UInt8]] = [
            // no ext type, no data
            [0xd4], [0xd5], [0xd6], [0xd7], [0xd8],
            // no ext type, no size, no data
            [0xc7], [0xc8], [0xc9],
            // no data
            [0xc7, 0x01],
            [0xc8, 0x00, 0x01],
            [0xc9, 0x00, 0x00, 0x00, 0x01]
        ]
        for bytes in testCollection {
            do {
                _ = try MessagePack.decode(bytes: bytes)
                fail("Expected deserializer to throw")
            } catch {
                assertEqual(error as? MessagePack.Error, .insufficientData)
            }
        }
    }
}
