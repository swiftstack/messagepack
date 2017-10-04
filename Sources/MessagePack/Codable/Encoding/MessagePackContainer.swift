protocol MessagePackContainer {
    var value: MessagePack { get }
}

enum MessagePackContainerType {
    case value(MessagePack)
    case container(MessagePackContainer)
}
