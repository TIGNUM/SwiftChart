//
//  RemoteNotificationHandler.swift
//  QOT
//
//  Created by Lee Arromba on 31/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import AirshipKit
import os.log

protocol RemoteNotificationHandlerDelegate: class {

    func remoteNotificationHandler(_ handler: RemoteNotificationHandler, canProcessNotificationResponse: UANotificationResponse) -> Bool
}

final class RemoteNotificationHandler: NSObject, UAPushNotificationDelegate {
    private var unhandledNotificationResponses = [UANotificationResponse]()
    private let launchHandler: LaunchHandler
    weak var delegate: RemoteNotificationHandlerDelegate?

    private var appDelegate: AppDelegate {
        return AppDelegate.current
    }

    init(launchHandler: LaunchHandler) {
        self.launchHandler = launchHandler
        super.init()
    }

    func receivedBackgroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let deepLinkURL = notificationContent.deepLinkURL {
            appDelegate.appCoordinator.handleIncommingNotificationDeepLinkURL(url: deepLinkURL)
        }
        appDelegate.appCoordinator.syncUserDependentData {
            completionHandler(.newData)
        }
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
        guard
            let deepLinkURL = notificationResponse.notificationContent.deepLinkURL,
            let notificationID = notificationResponse.notificationContent.notificationID  else { return }
        launchHandler.process(url: deepLinkURL, notificationID: notificationID)
    }
}

// MARK: Helpers

private extension UANotificationContent {

    var deepLinkURL: URL? {
        guard let deepLink = notificationInfo["^d"] as? String, let url = URL(string: deepLink) else { return nil }
        return url
    }

    var notificationID: String? {
        return notificationInfo["notificationId"] as? String
    }
}
