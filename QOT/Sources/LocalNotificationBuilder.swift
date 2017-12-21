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
    private let queue = DispatchQueue(label: "com.tignum.qot.local.notification", qos: .background)

    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }

    func setup() {
        let notifications = guideNotifications(realmProvider: realmProvider)
        let notificationsIDs = notifications.map { $0.localID }
        pendingNotificationIDs(notificationsIDs: notificationsIDs) { (newIDs: [String]) in
            let newNotifications = notifications.filter { newIDs.contains($0.localID) == true }

            newNotifications.forEach { (itemNotification: RealmGuideItemNotification) in
                if itemNotification.reminderTime != nil {
                    self.create(notification: itemNotification)
                }
            }
        }
    }

    static func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

// MARK: - Private

private extension LocalNotificationBuilder {

    func pendingNotificationIDs(notificationsIDs: [String], completion: @escaping ([String]) -> Void) {
        queue.async {
            UNUserNotificationCenter.current().getPendingNotificationRequests { (pendingRequests) in
                let requestIDs = pendingRequests.map { $0.identifier }
                let newIDs = notificationsIDs.filter { requestIDs.contains($0) == false }
                DispatchQueue.main.async {
                    completion(newIDs)
                }
            }
        }
    }

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
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: ((60 * 2)), repeats: true)
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
    }
}
