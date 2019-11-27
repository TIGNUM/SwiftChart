//
//  QOTReachability.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 09/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

enum ReachabilityStatus {
    case notReachable
    case ethernetOrWiFi
    case wwan
}

protocol QOTReachabilityInterface {

    var status: ReachabilityStatus { get }
    var isReachableOnEthernetOrWiFi: Bool { get }
    var isReachable: Bool { get }
    var onStatusChange: ((ReachabilityStatus) -> Void)? { get }
}

class QOTReachability: QOTReachabilityInterface {

    var onStatusChange: ((ReachabilityStatus) -> Void)?

    private let reachability = Reachability(hostName: "http://google.com")

    var status: ReachabilityStatus {
        return convert(reachability?.currentReachabilityStatus())
    }

    var isReachableOnEthernetOrWiFi: Bool {
        guard let status = reachability?.currentReachabilityStatus() else {
            return false
        }
        if case NetworkStatus.ReachableViaWiFi = status {
            return true
        }
        return false
    }
    var isReachable: Bool {
        guard let status = reachability?.currentReachabilityStatus() else {
            return false
        }
        if case NetworkStatus.NotReachable = status {
            return false
        }
        return true
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkForReachability),
                                               name: NSNotification.Name.reachabilityChanged,
                                               object: nil)
        reachability?.startNotifier()
    }

    @objc func checkForReachability(notification: NSNotification) {
        guard let networkReachability = notification.object as? Reachability else { return }
        let remoteHostStatus = networkReachability.currentReachabilityStatus()
        onStatusChange?(convert(remoteHostStatus))
    }
}

// MARK: - Private methods
private extension QOTReachability {
    func convert(_ status: NetworkStatus?) -> ReachabilityStatus {
        guard let status = status else { return .notReachable }
        switch status {
        case .NotReachable: return .notReachable
        case .ReachableViaWiFi: return .ethernetOrWiFi
        case .ReachableViaWWAN: return .wwan
        }
    }
}
