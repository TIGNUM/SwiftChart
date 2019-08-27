//
//  LocationPermissionWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LocationPermissionWorker {

    // MARK: - Properties
    private let permissionManager: PermissionsManager

    lazy var title: String = {
        return R.string.localized.onboardingRegistrationLocationPermissionTitle()
    }()

    lazy var descriptionText: String = {
        return R.string.localized.onboardingRegistrationLocationPermissionDescription()
    }()

    lazy var skipButton: String = {
        return R.string.localized.onboardingRegistrationLocationPermissionButtonSkip()
    }()

    lazy var allowButton: String = {
        return R.string.localized.onboardingRegistrationLocationPermissionButtonAllow()
    }()

    lazy var permissionDeniedMessage: String = {
        return R.string.localized.onboardingRegistrationLocationPermissionAlertMessage()
    }()

    lazy var alertSettingsButton: String = {
        return R.string.localized.onboardingRegistrationLocationPermissionAlertSettings()
    }()

    lazy var alertSkipButton: String = {
        return R.string.localized.onboardingRegistrationLocationPermissionAlertSkip()
    }()

    // MARK: - Init
    init(permissionManager: PermissionsManager = AppCoordinator.appState.permissionsManager) {
        self.permissionManager = permissionManager
    }

    func requestLocationAccess(completion: @escaping (PermissionsManager.AuthorizationStatus) -> Void) {
        permissionManager.askPermission(for: [.location]) { (statusDict) in
            let status: PermissionsManager.AuthorizationStatus
            if let resultStatus = statusDict[.location] {
                status = resultStatus
            } else {
                status = .denied
            }
            completion(status)
        }
    }
}
