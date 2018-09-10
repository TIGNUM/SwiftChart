//
//  DeviceIdentifier.swift
//  QOT
//
//  Created by Sam Wyndham on 15.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

private let keychain = Keychain()

let deviceID: String = {
    var returnValue: String = ""
    if let identifier = keychain[string: .deviceID] {
        returnValue = identifier
    } else {
        let identifier = UUID().uuidString
        keychain[string: .deviceID] = identifier
        returnValue = identifier
    }

    // To help Backend, put Prefix to identify Simulator request.
    #if targetEnvironment(simulator)
    return "SIMULATOR-" + returnValue
    #else
    return returnValue
    #endif
}()
