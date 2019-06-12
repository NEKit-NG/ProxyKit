import Foundation

public enum ProxyServerEvent: EventType {
    public var description: String {
        switch self {
        case let .newSocketAccepted(socket, onServer: server):
            return "Proxy server \(server) just accepted a new socket \(socket)."
        case let .pipeClosed(pipe, onServer: server):
            return "A pipe \(pipe) on proxy server \(server) just closed."
        case .started(let server):
            return "Proxy server \(server) started."
        case .stopped(let server):
            return "Proxy server \(server) stopped."
        }
    }

    case newSocketAccepted(ProxySocket, onServer: ProxyServer), pipeClosed(Pipe, onServer: ProxyServer), started(ProxyServer), stopped(ProxyServer)
}
