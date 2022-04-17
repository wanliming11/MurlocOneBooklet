//
//  NetworkNotif.swift
//  SharkOne (iOS)
//
//  Created by Murloc Wan on 2022/4/17.
//

import Network
import Combine

final class NetworkNotif: ObservableObject {
    static let shared = NetworkNotif()
    
    private(set) lazy var pb = mkpb()
    @Published private(set) var pt: NWPath
    
    private let monitor: NWPathMonitor
    private lazy var sj = CurrentValueSubject<NWPath, Never>(monitor.currentPath)
    
    init() {
        monitor = NWPathMonitor()
        pt = monitor.currentPath
        monitor.pathUpdateHandler = { [weak self] path in
            self?.pt = path
            self?.sj.send(path)
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    deinit {
        monitor.cancel()
        sj.send(completion: .finished)
    }
    
    private func mkpb() -> AnyPublisher<NWPath, Never> {
        return sj.eraseToAnyPublisher()
    }
}


struct CombineNotif {
    static func thinking() {
        var sb = Set<AnyCancellable>()
        var alertMsg = ""

        NetworkNotif.shared.pb
            .sink { path in
                print(path)
            } receiveValue: { path in
                alertMsg = path.debugDescription
                switch path.status {
                case .satisfied:
                    alertMsg = "Good Network"
                case .unsatisfied:
                    alertMsg = "😨"
                case .requiresConnection:
                    alertMsg = "🥱"
                @unknown default:
                    alertMsg = "🤔"
                }
                
                if path.status == .unsatisfied {
                    if #available(iOS 14.2, *) {
                        switch path.unsatisfiedReason {
                        case .notAvailable:
                            alertMsg += "网络不可用"
                        case .cellularDenied:
                            alertMsg += "蜂窝网不可用"
                        case .wifiDenied:
                            alertMsg += "Wifi 不可用"
                        case .localNetworkDenied:
                            alertMsg += "网线不可用"
                        @unknown default:
                            alertMsg += "网络不可用"
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                print(alertMsg)
            }.store(in: &sb)
    }
}
