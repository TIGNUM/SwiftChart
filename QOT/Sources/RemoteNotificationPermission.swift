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

struct RemoteNotificationPermission: PermissionInterface {
    let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()

    func authorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings(completionHandler: { (settings) in
            completion(settings.authorizationStatus)
        })
    }

    func authorizationStatusDescription(completion: @escaping (String) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                completion("notDetermined")
            case .provisional:
                completion("restricted")
            case .denied:
                completion("denied")
            default:
                completion("authorized")
            }
        }
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
    var stringValue: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        case .provisional:
            return "provisional"
        }
    }
}
