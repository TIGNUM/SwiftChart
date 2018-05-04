//
//  AppDelegate+Buglife.swift
//  QOT
//
//  Created by Sam Wyndham on 08.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Buglife
import AirshipKit

extension AppDelegate: BuglifeDelegate {

    func buglife(_ buglife: Buglife, titleForPromptWithInvocation invocation: LIFEInvocationOptions = []) -> String? {
        // A slight hack. Rather than updating Bulife on logout and login etc we intecept it just before it's shown.
        let username = CredentialsManager.shared.loginCredentials()?.username ?? "No username"
        let apnsDeviceToken = UAirship.push().deviceToken ?? "No token"
        buglife.setUserEmail(username)
        buglife.setStringValue(apnsDeviceToken, forAttribute: "APNS Devive Token")
        return nil
    }
}
