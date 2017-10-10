extension MessagePack {
    public enum Error: Swift.Error {
        case streamWriteError
        case insufficientData
        case invalidData
    }
}
