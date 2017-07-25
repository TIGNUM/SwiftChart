//
//  RemoteNotificationHandler.swift
//  QOT
//
//  Created by Lee Arromba on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import UserNotifications

protocol RemoteNotificationHandlerDelegate: class {
    func remoteNotificationHandler(_ remoteNotificationHandler: RemoteNotificationHandler, didReceiveNotification notification: UNNotification, withIdentifier identifier: String)
    func remoteNotificationHandler(_ remoteNotificationHandler: RemoteNotificationHandler, didFailToRegisterForRemoteNotificationsWithError error: Error)
}

class RemoteNotificationHandler: NSObject {
    struct LocalNotifcationIdentifier {
        static let interviewIdentifier = "qot.local.notification.morning.interview"
        static let weeklyChoicesIdentifier = "qot.local.notification.morning.weekly.choices"
    }
    
    weak var delegate: RemoteNotificationHandlerDelegate?
    var deviceToken: Data?
    private let permissionHandler: PermissionHandler
    private var notificationCenter: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
    init(delegate: RemoteNotificationHandlerDelegate, permissionHandler: PermissionHandler) {
        self.delegate = delegate
        self.permissionHandler = permissionHandler
        super.init()
    }
    
    func isAuthorised(_ completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            completion(settings.authorizationStatus == .authorized)
        }
    }
        
    func registerRemoteNotifications(completion: ((Bool) -> Void)?) {
        permissionHandler.askPermissionForRemoteNotifications { (granted: Bool) in
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
            completion?(granted)
        }
    }
    
    func triggerLocalNotification(withTitle title: String? = nil, subtitle: String? = nil, body: String? = nil, identifier: String, userInfo: [AnyHashable : Any]? = nil, completion: ((Error?) -> Void)? = nil) {
        let content = UNMutableNotificationContent()
        if let title = title {
            content.title = title
        }
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        if let body = body {
            content.body = body
        }
        if let userInfo = userInfo {
            content.userInfo = userInfo
        }
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.delegate = self
        notificationCenter.add(request) { (error) in
            completion?(error)
        }
    }

    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        self.deviceToken = deviceToken
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        delegate?.remoteNotificationHandler(self, didFailToRegisterForRemoteNotificationsWithError: error)
    }
}

extension RemoteNotificationHandler: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        delegate?.remoteNotificationHandler(self, didReceiveNotification: response.notification, withIdentifier: identifier)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
