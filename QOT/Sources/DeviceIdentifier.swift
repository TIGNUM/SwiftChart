//
//  DeviceIdentifier.swift
//  QOT
//
//  Created by Sam Wyndham on 15.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import KeychainAccess

private let keychain = Keychain(service: KeychainConstant.service.rawValue)

let deviceID: String = {
    if let identifier = keychain[KeychainConstant.deviceID.rawValue] {
        return identifier
    } else {
        let identifier = UUID().uuidString
        keychain[KeychainConstant.deviceID.rawValue] = identifier
        return identifier
    }
}()
