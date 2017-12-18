//
//  LocalNotificationBuilder.swift
//  QOT
//
//  Created by karmic on 15.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UserNotifications

protocol LocalNotificationBuildable {

    func content(_ notification: RealmGuideItemNotification) -> UNMutableNotificationContent

    func trigger(_ notification: RealmGuideItemNotification) -> UNCalendarNotificationTrigger

    func addNotification(request: UNNotificationRequest)

    func cancelNotification(identifier: String)
}

final class LocalNotificationBuilder: NSObject, LocalNotificationBuildable {

    static let shared = LocalNotificationBuilder()

    private override init() {}

    func create(notification: RealmGuideItemNotification) {
        let request = UNNotificationRequest(identifier: notification.remoteID.description,
                                            content: content(notification),
                                            trigger: trigger(notification))
        addNotification(request: request)
    }
}

// MARK: -

extension LocalNotificationBuilder {

    func content(_ notification: RealmGuideItemNotification) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        if let title = notification.title {
            content.title = title
        }
        content.body = notification.body
        content.sound = UNNotificationSound(named: notification.sound)
        content.userInfo = ["link": notification.link]

        return content
    }

    func trigger(_ notification: RealmGuideItemNotification) -> UNCalendarNotificationTrigger {
        let date = Date(timeIntervalSinceNow: 3600)
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                          from: date/*notification.issueDate*/)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                             repeats: false)
    }

    func addNotification(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                log(error, level: .error)
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }

    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension LocalNotificationBuilder: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        print("willPresent: ", notification)
        print("willPresent: ", notification.request.content.userInfo)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        print("didReceive: ", response.notification.request.content)
        print("didReceive: ", response.notification.request.content.userInfo)
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}
