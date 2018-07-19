//
//  Connectivity.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 06/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Connectivity {

    static func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false { return false }
        return (flags.contains(.reachable) == true && flags.contains(.connectionRequired) == false)
    }
}
