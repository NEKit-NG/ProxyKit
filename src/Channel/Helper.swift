import Foundation

open class ConnectSession {
    public enum EventSourceEnum {
        case proxy, adapter, channel
    }

    // The requested host.
    ///
    /// This is the host received in the request. May be a domain, a real IP or a fake IP.
    public let requestedHost: String

    /// The real host for this session.
    ///
    /// If the session is initailized with a host domain, then `host == requestedHost`.
    /// Otherwise, the requested IP address is looked up in the DNS server to see if it corresponds to a domain if `fakeIPEnabled` is `true`.
    /// Unless there is a good reason not to, any socket shoule connect based on this directly.
    public var host: String

    /// The requested port.
    public let port: Int

    public var error: Error?
    public var errorSource: EventSourceEnum?
    public var disconnectedBy: EventSourceEnum?

    /// The resolved IP address.
    ///
    /// - note: This will always be real IP address.
    public lazy var ipAddress: String = {
        [unowned self] in
        if self.isIP() {
            return self.host
        } else {
            let ip = Utils.DNS.resolve(self.host)
            return ip
        }
    }()

    public init(host: String, port: Int) {
        self.requestedHost = host
        self.port = port
        self.host = host
    }

    func disconnected(becauseOf error: Error? = nil, by source: EventSourceEnum) {
        if disconnectedBy == nil {
            self.error = error
            if error != nil {
                errorSource = source
            }
            disconnectedBy = source
        }
    }

    public func isIPv4() -> Bool {
        return Utils.IP.isIPv4(host)
    }

    public func isIPv6() -> Bool {
        return Utils.IP.isIPv6(host)
    }

    public func isIP() -> Bool {
        return isIPv4() || isIPv6()
    }
}

extension ConnectSession: CustomStringConvertible {
    public var description: String {
        if requestedHost != host {
            return "<\(type(of: self)) host:\(host) port:\(port) requestedHost:\(requestedHost)>"
        } else {
            return "<\(type(of: self)) host:\(host) port:\(port)>"
        }
    }
}

/// The class managing rules.
open class RuleManager {
    /// The current used `RuleManager`, there is only one manager should be used at a time.
    ///
    /// - note: This should be set before any DNS or connect sessions.
    public static var currentManager: RuleManager = RuleManager(fromRules: [], appendDirect: true)

    /// The rule list.
    var rules: [Rule] = []

    open var observer: Observer<RuleMatchEvent>?

    /**
     Create a new `RuleManager` from the given rules.
     
     - parameter rules:        The rules.
     - parameter appendDirect: Whether to append a `DirectRule` at the end of the list so any request does not match with any rule go directly.
     */
    public init(fromRules rules: [Rule], appendDirect: Bool = false) {
        self.rules = rules
        
        if appendDirect || self.rules.count == 0 {
            self.rules.append(DirectRule())
        }
        
        observer = ObserverFactory.currentFactory?.getObserverForRuleManager(self)
    }

    /**
     Match connect session to all rules.
     
     - parameter session: connect session to match.
     
     - returns: The matched configured adapter.
     */
    func match(_ session: ConnectSession) -> AdapterFactory! {
        return DirectAdapterFactory()
    }
}

/**
 Represents the type of the socket.
 
 - NW:  The socket based on `NWTCPConnection`.
 - GCD: The socket based on `GCDAsyncSocket`.
 */
public enum SocketBaseType {
    case nw, gcd
}

/// Factory to create `RawTCPSocket` based on configuration.
open class RawSocketFactory {
    /// Current active `NETunnelProvider` which creates `NWTCPConnection` instance.
    ///
    /// - note: Must set before any connection is created if `NWTCPSocket` or `NWUDPSocket` is used.
    //public static weak var TunnelProvider: NETunnelProvider?
    
    /**
     Return `RawTCPSocket` instance.
     
     - parameter type: The type of the socket.
     
     - returns: The created socket instance.
     */
    public static func getRawSocket(_ type: SocketBaseType? = nil) -> RawTCPSocketProtocol {
        return GCDTCPSocket()
    }
}
