//
//  NotificationPermissionWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class NotificationPermissionWorker {

    // MARK: - Properties
    private let permissionManager: PermissionsManager?

    lazy var title: String = {
        return R.string.localized.onboardingRegistrationNotificationPermissionTitle()
    }()

    lazy var descriptionText: String = {
        return R.string.localized.onboardingRegistrationNotificationPermissionDescription()
    }()

    lazy var skipButton: String = {
        return R.string.localized.onboardingRegistrationNotificationPermissionButtonSkip()
    }()

    lazy var allowButton: String = {
        return R.string.localized.onboardingRegistrationNotificationPermissionButtonAllow()
    }()

    lazy var permissionDeniedMessage: String = {
        return R.string.localized.onboardingRegistrationNotificationPermissionAlertMessage()
    }()

    lazy var alertSettingsButton: String = {
        return R.string.localized.onboardingRegistrationNotificationPermissionAlertSettings()
    }()

    lazy var alertSkipButton: String = {
        return R.string.localized.onboardingRegistrationNotificationPermissionAlertSkip()
    }()

    // MARK: - Init
    init(permissionManager: PermissionsManager? = nil) {
        self.permissionManager = permissionManager
    }

    func requestNotificationAccess(completion: @escaping (PermissionsManager.AuthorizationStatus) -> Void) {
        let requestedPermissions: PermissionsManager.Permission.Identifier = .notifications
        permissionManager?.askPermission(for: [requestedPermissions]) { (statusDict) in
            let status: PermissionsManager.AuthorizationStatus
            if let resultStatus = statusDict[requestedPermissions] {
                status = resultStatus
            } else {
                status = .denied
            }
            completion(status)
        }
    }
}
