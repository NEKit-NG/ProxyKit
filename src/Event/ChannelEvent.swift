import Foundation

public enum ChannelEvent: EventType {
    public var description: String {
        switch self {
        case .opened(let channel):
            return "Channel \(channel) starts processing data."
        case .closeCalled(let channel):
            return "Close is called on channel \(channel)."
        case .forceCloseCalled(let channel):
            return "Force close is called on channel \(channel)."
        case let .receivedRequest(request, from: socket, on: channel):
            return "Channel \(channel) received request \(request) from proxy socket \(socket)."
        case let .receivedReadySignal(socket, currentReady: signal, on: channel):
            if signal == 1 {
                return "Channel \(channel) received ready-for-forward signal from socket \(socket)."
            } else {
                return "Channel \(channel) received ready-for-forward signal from socket \(socket). Start forwarding data."
            }
        case let .proxySocketReadData(data, from: socket, on: channel):
            return "Channel \(channel) received \(data.count) bytes from proxy socket \(socket)."
        case let .proxySocketWroteData(data, by: socket, on: channel):
            if let data = data {
                return "Proxy socket \(socket) sent \(data.count) bytes data from Channel \(channel)."
            } else {
                return "Proxy socket \(socket) sent data from Channel \(channel)."
            }
        case let .adapterSocketReadData(data, from: socket, on: channel):
            return "Channel \(channel) received \(data.count) bytes from adapter socket \(socket)."
        case let .adapterSocketWroteData(data, by: socket, on: channel):
            if let data = data {
                return "Adatper socket \(socket) sent \(data.count) bytes data from Channel \(channel)."
            } else {
                return "Adapter socket \(socket) sent data from Channel \(channel)."
            }
        case let .connectedToRemote(socket, on: channel):
            return "Adapter socket \(socket) connected to remote successfully on channel \(channel)."
        case let .updatingAdapterSocket(from: old, to: new, on: channel):
            return "Updating adapter socket of channel \(channel) from \(old) to \(new)."
        case .closed(let channel):
            return "Channel \(channel) closed."
        }
    }

    case opened(Channel),
    closeCalled(Channel),
    forceCloseCalled(Channel),
    receivedRequest(ConnectSession, from: ProxySocket, on: Channel),
    receivedReadySignal(SocketProtocol, currentReady: Int, on: Channel),
    proxySocketReadData(Data, from: ProxySocket, on: Channel),
    proxySocketWroteData(Data?, by: ProxySocket, on: Channel),
    adapterSocketReadData(Data, from: AdapterSocket, on: Channel),
    adapterSocketWroteData(Data?, by: AdapterSocket, on: Channel),
    connectedToRemote(AdapterSocket, on: Channel),
    updatingAdapterSocket(from: AdapterSocket, to: AdapterSocket, on: Channel),
    closed(Channel)
}
