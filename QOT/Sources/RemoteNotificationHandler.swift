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
    
    init(delegate: RemoteNotificationHandlerDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    func isAuthorised(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            completion(settings.authorizationStatus == .authorized)
        }
    }
        
    func registerRemoteNotifications(completion: ((Error?) -> Void)?) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (_: Bool, error: Error?) in
            if error == nil {
                UIApplication.shared.registerForRemoteNotifications()
            }
            completion?(error)
        }
    }
    
    func triggerLocalNotification(withTitle title: String? = nil, subtitle: String? = nil, body: String? = nil, identifier: String, userInfo: [AnyHashable : Any]? = nil, completion: ((Error?) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
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
        center.delegate = self
        center.add(request) { (error) in
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
