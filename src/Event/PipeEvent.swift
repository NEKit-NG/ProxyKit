import Foundation

public enum PipeEvent: EventType {
    public var description: String {
        switch self {
        case .opened(let pipe):
            return "Pipe \(pipe) starts processing data."
        case .closeCalled(let pipe):
            return "Close is called on pipe \(pipe)."
        case .forceCloseCalled(let pipe):
            return "Force close is called on pipe \(pipe)."
        case let .receivedRequest(request, from: socket, on: pipe):
            return "Pipe \(pipe) received request \(request) from proxy socket \(socket)."
        case let .receivedReadySignal(socket, currentReady: signal, on: pipe):
            if signal == 1 {
                return "Pipe \(pipe) received ready-for-forward signal from socket \(socket)."
            } else {
                return "Pipe \(pipe) received ready-for-forward signal from socket \(socket). Start forwarding data."
            }
        case let .proxySocketReadData(data, from: socket, on: pipe):
            return "Pipe \(pipe) received \(data.count) bytes from proxy socket \(socket)."
        case let .proxySocketWroteData(data, by: socket, on: pipe):
            if let data = data {
                return "Proxy socket \(socket) sent \(data.count) bytes data from Pipe \(pipe)."
            } else {
                return "Proxy socket \(socket) sent data from Pipe \(pipe)."
            }
        case let .adapterSocketReadData(data, from: socket, on: pipe):
            return "Pipe \(pipe) received \(data.count) bytes from adapter socket \(socket)."
        case let .adapterSocketWroteData(data, by: socket, on: pipe):
            if let data = data {
                return "Adatper socket \(socket) sent \(data.count) bytes data from Pipe \(pipe)."
            } else {
                return "Adapter socket \(socket) sent data from Pipe \(pipe)."
            }
        case let .connectedToRemote(socket, on: pipe):
            return "Adapter socket \(socket) connected to remote successfully on pipe \(pipe)."
        case let .updatingAdapterSocket(from: old, to: new, on: pipe):
            return "Updating adapter socket of pipe \(pipe) from \(old) to \(new)."
        case .closed(let pipe):
            return "Pipe \(pipe) closed."
        }
    }

    case opened(Pipe),
    closeCalled(Pipe),
    forceCloseCalled(Pipe),
    receivedRequest(ConnectSession, from: ProxySocket, on: Pipe),
    receivedReadySignal(SocketProtocol, currentReady: Int, on: Pipe),
    proxySocketReadData(Data, from: ProxySocket, on: Pipe),
    proxySocketWroteData(Data?, by: ProxySocket, on: Pipe),
    adapterSocketReadData(Data, from: AdapterSocket, on: Pipe),
    adapterSocketWroteData(Data?, by: AdapterSocket, on: Pipe),
    connectedToRemote(AdapterSocket, on: Pipe),
    updatingAdapterSocket(from: AdapterSocket, to: AdapterSocket, on: Pipe),
    closed(Pipe)
}
