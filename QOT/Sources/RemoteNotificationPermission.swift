//
//  RemoteNotificationPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UserNotifications

struct RemoteNotificationPermission: PermissionInterface {
    let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()

    func authorizationStatusDescription(completion: @escaping (String) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus.stringValue)
        }
    }

    func askPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { (granted: Bool, _: Error?) in
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
        }
    }
}
