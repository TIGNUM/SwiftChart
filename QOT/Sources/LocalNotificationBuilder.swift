//
//  LocalNotificationBuilder.swift
//  QOT
//
//  Created by karmic on 15.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UserNotifications
import RealmSwift

final class LocalNotificationBuilder: NSObject {

    private let realmProvider: RealmProvider

    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }

    func setup() {
        let notifications = guideNotifications(realmProvider: realmProvider)

        notifications.map { $0.localID }.forEach { (identifier: String) in
            cancelNotification(identifier: identifier)
        }

        notifications.forEach { (itemNotification: RealmGuideItemNotification) in
            if itemNotification.reminderTime != nil {
                create(notification: itemNotification)
            }
        }
    }
}

// MARK: - Private

private extension LocalNotificationBuilder {

    func guideNotifications(realmProvider: RealmProvider) -> [RealmGuideItemNotification] {
        var notifications = [RealmGuideItemNotification]()
        do {
            let realm = try realmProvider.realm()
            notifications = Array(realm.objects(RealmGuideItemNotification.self))
        } catch {
            log(error, level: .error)
        }

        return notifications
    }

    func create(notification: RealmGuideItemNotification) {
        let request = UNNotificationRequest(identifier: notification.localID,
                                            content: content(notification),
                                            trigger: trigger(notification))
        addNotification(request: request)
    }

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
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                          from: notification.issueDate)
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

    func handleNotification(notification: UNNotification) {
        guard
            let linkString = notification.request.content.userInfo["link"] as? String,
            let link = URL(string: linkString) else {
                return
        }

        let launchHandler = LaunchHandler()
        launchHandler.process(url: link)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension LocalNotificationBuilder: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        handleNotification(notification: notification)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        handleNotification(notification: response.notification)
    }
}
