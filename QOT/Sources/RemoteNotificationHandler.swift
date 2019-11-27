//
//  RemoteNotificationHandler.swift
//  QOT
//
//  Created by Lee Arromba on 31/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import AirshipKit
import os.log

final class RemoteNotificationHandler: NSObject, UAPushNotificationDelegate {
    private var unhandledNotificationResponses = [UANotificationResponse]()
    private let launchHandler: LaunchHandler

    private var appDelegate: AppDelegate {
        return AppDelegate.current
    }

    init(launchHandler: LaunchHandler) {
        self.launchHandler = launchHandler
        super.init()
    }

    func receivedBackgroundNotification(_ notificationContent: UANotificationContent,
                                        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let deepLinkURL = notificationContent.deepLinkURL {
            appDelegate.appCoordinator.handleIncommingNotificationDeepLinkURL(url: deepLinkURL,
                                                                              completionHandler: completionHandler)
        } else {
            completionHandler(.noData)
        }
    }

    func receivedNotificationResponse(_ notificationResponse: UANotificationResponse,
                                      completionHandler: @escaping () -> Void) {
        process(notificationResponse)
        completionHandler()
    }

    func receivedForegroundNotification(_ notificationContent: UANotificationContent,
                                        completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func presentationOptions(for notification: UNNotification) -> UNNotificationPresentationOptions {
        return [.alert, .sound]
    }

    // MARK: - private

    private func process(_ notificationResponse: UANotificationResponse) {
        guard let deepLinkURL = notificationResponse.notificationContent.deepLinkURL  else { return }
        launchHandler.process(url: deepLinkURL)
    }
}

// MARK: Helpers

private extension UANotificationContent {

    var deepLinkURL: URL? {
        guard let deepLink = notificationInfo["^d"] as? String, let url = URL(string: deepLink) else { return nil }
        return url
    }
}
