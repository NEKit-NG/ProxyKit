import Foundation

open class ObserverFactory {
    public static var currentFactory: ObserverFactory?

    public init() {}

    open func getObserverForPipe(_ pipe: Pipe) -> Observer<PipeEvent>? {
        return nil
    }

    open func getObserverForAdapterSocket(_ socket: AdapterSocket) -> Observer<AdapterSocketEvent>? {
        return nil
    }

    open func getObserverForProxySocket(_ socket: ProxySocket) -> Observer<ProxySocketEvent>? {
        return nil
    }

    open func getObserverForProxyServer(_ server: ProxyServer) -> Observer<ProxyServerEvent>? {
        return nil
    }

    open func getObserverForRuleManager(_ manager: RuleManager) -> Observer<RuleMatchEvent>? {
        return nil
    }
}
