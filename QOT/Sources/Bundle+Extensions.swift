//
//  Bundle+Extensions.swift
//  QOT
//
//  Created by Moucheg Mouradian on 31/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Bundle {

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? String.empty
    }

    var isFirstVersion: Bool {
        return UserDefault.lastInstaledAppVersion.stringValue == nil
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? String.empty
    }

    var versionAndBuildNumber: String {
        return String(format: "Version %@ (%@)", versionNumber, buildNumber)
    }
}
