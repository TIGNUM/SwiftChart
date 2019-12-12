//
//  Notification+Name.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 09/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension Notification.Name {
    struct RegistrationKeys {
        static let email = "email"
        static let toBeVision = "toBeVision"
    }

    static let registrationShouldShowLogin = Notification.Name("registrationShouldShowLogin")
}
