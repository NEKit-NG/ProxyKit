import Foundation
import CocoaAsyncSocket
import Resolver
import IPStack

/**
 The base proxy server class.
 
 This proxy does not listen on any port.
 */
open class ProxyServer: NSObject, ChannelDelegate {
    typealias ChannelArray = [Channel]

    /// The port of proxy server.
    public let port: IPort

    /// The address of proxy server.
    public let address: IPAddress?

    /// The type of the proxy server.
    ///
    /// This can be set to anything describing the proxy server.
    public let type: String

    /// The description of proxy server.
    open override var description: String {
        return "<\(type) address:\(String(describing: address)) port:\(port)>"
    }

    open var observer: Observer<ProxyServerEvent>?

    var channels: ChannelArray = []

    /**
     Create an instance of proxy server.
     
     - parameter address: The address of proxy server.
     - parameter port:    The port of proxy server.
     
     - warning: If you are using Network Extension, you have to set address or you may not able to connect to the proxy server.
     */
    public init(address: IPAddress?, port: IPort) {
        self.address = address
        self.port = port
        type = "\(Swift.type(of: self))"

        super.init()

        self.observer = ObserverFactory.currentFactory?.getObserverForProxyServer(self)
    }

    /**
     Start the proxy server.
     
     - throws: The error occured when starting the proxy server.
     */
    open func start() throws {
        QueueFactory.executeOnQueueSynchronizedly {
            GlobalIntializer.initalize()
            self.observer?.signal(.started(self))
        }
    }

    /**
     Stop the proxy server.
     */
    open func stop() {
        QueueFactory.executeOnQueueSynchronizedly {
            for channel in channels {
                channel.forceClose()
            }

            observer?.signal(.stopped(self))
        }
    }

    /**
     Delegate method when the proxy server accepts a new ProxySocket from local.
     
     When implementing a concrete proxy server, e.g., HTTP proxy server, the server should listen on some port and then wrap the raw socket in a corresponding ProxySocket subclass, then call this method.
     
     - parameter socket: The accepted proxy socket.
     */
    func didAcceptNewSocket(_ socket: ProxySocket) {
        observer?.signal(.newSocketAccepted(socket, onServer: self))
        let channel = Channel(proxySocket: socket)
        channel.delegate = self
        channels.append(channel)
        channel.openChannel()
    }

    // MARK: ChannelDelegate implementation

    /**
     Delegate method when a channel closed. The server will remote it internally.
     
     - parameter channel: The closed channel.
     */
    func channelDidClose(_ channel: Channel) {
        observer?.signal(.channelClosed(channel, onServer: self))
        guard let index = channels.firstIndex(of: channel) else {
            // things went strange
            return
        }

        channels.remove(at: index)
    }
}
