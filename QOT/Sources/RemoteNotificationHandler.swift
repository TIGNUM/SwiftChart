//
//  RemoteNotificationHandler.swift
//  QOT
//
//  Created by Lee Arromba on 31/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import AirshipKit

protocol RemoteNotificationHandlerDelegate: class {
    func remoteNotificationHandler(_ handler: RemoteNotificationHandler, canProcessNotificationResponse: UANotificationResponse) -> Bool
}

class RemoteNotificationHandler: NSObject, UAPushNotificationDelegate {
    private var unhandledNotificationResponses = [UANotificationResponse]()
    private let launchHandler: LaunchHandler
    weak var delegate: RemoteNotificationHandlerDelegate?

    init(launchHandler: LaunchHandler) {
        self.launchHandler = launchHandler
        super.init()
    }
    
    func receivedNotificationResponse(_ notificationResponse: UANotificationResponse, completionHandler: @escaping () -> Void) {
        if delegate?.remoteNotificationHandler(self, canProcessNotificationResponse: notificationResponse) ?? false {
            process(notificationResponse)
        } else {
            unhandledNotificationResponses.append(notificationResponse)
        }
        completionHandler()
    }
    
    func receivedForegroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func presentationOptions(for notification: UNNotification) -> UNNotificationPresentationOptions {
        return [.alert, .sound]
    }
    
    func processOutstandingNotifications() {
        if let notificationResponse = unhandledNotificationResponses.first {
            process(notificationResponse)
            unhandledNotificationResponses.removeAll() // TODO: maybe we can handle all of them in the future?
        }
    }
    
    // MARK: - private
    
    private func process(_ notificationResponse: UANotificationResponse) {
        if
            let deepLink = notificationResponse.notificationContent.notificationInfo.values.first as? String,
            let url = URL(string: deepLink) {
            launchHandler.process(url: url)
        }
    }
}
