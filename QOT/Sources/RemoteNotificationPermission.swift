//
//  RemoteNotificationPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UserNotifications
import AirshipKit

class RemoteNotificationPermission: PermissionInterface {
    var status: UNAuthorizationStatus = .notDetermined
    let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()

    func refreshStatus(completion: @escaping () -> Void) {
        notificationCenter.getNotificationSettings { settings in
            self.status = settings.authorizationStatus
            completion()
        }
    }

    func authorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings(completionHandler: { (settings) in
            completion(settings.authorizationStatus)
        })
    }

    func authorizationStatusDescription() -> PermissionsManager.AuthorizationStatus {
        return self.status.authorizationStatus
    }

    func askPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { (granted: Bool, _: Error?) in
            UAirship.push().userPushNotificationsEnabled = granted
            completion(granted)
        }
    }
}

// MARK: - UNAuthorizationStatus

private extension UNAuthorizationStatus {
    var authorizationStatus: PermissionsManager.AuthorizationStatus {
        switch self {
        case .notDetermined:
            return PermissionsManager.AuthorizationStatus.notDetermined
        case .denied:
            return PermissionsManager.AuthorizationStatus.denied
        case .provisional:
            return PermissionsManager.AuthorizationStatus.restricted
        case .authorized:
            return PermissionsManager.AuthorizationStatus.granted
        }
    }
}
