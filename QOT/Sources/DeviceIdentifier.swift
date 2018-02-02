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
    if let identifier = keychain[string: .deviceID] {
        return identifier
    } else {
        let identifier = UUID().uuidString
        keychain[string: .deviceID] = identifier
        return identifier
    }
}()
