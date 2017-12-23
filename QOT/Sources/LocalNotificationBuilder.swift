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

    func addLearnItemNotifications(learnItems: List<RealmGuideItemLearn>) {
        learnItems.forEach { (itemLearn: RealmGuideItemLearn) in
            if itemLearn.reminderTime != nil {
                self.create(itemLearn: itemLearn)
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
                                            content: content(title: notification.title,
                                                             body: notification.body,
                                                             sound: notification.sound,
                                                             link: notification.link),
                                            trigger: trigger(notification.issueDate))
        addNotification(request: request)
    }

    func create(itemLearn: RealmGuideItemLearn) {
        let request = UNNotificationRequest(identifier: itemLearn.localID,
                                            content: content(title: itemLearn.title,
                                                             body: itemLearn.body,
                                                             sound: itemLearn.sound,
                                                             link: itemLearn.link),
                                            trigger: trigger(itemLearn.createdAt))
        addNotification(request: request)
    }

    func content(title: String?, body: String, sound: String, link: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        if let title = title {
            content.title = title
        }
        content.body = body
        content.sound = UNNotificationSound(named: sound)
        content.userInfo = ["link": link]

        return content
    }

    func trigger(_ issueDate: Date) -> UNCalendarNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                          from: issueDate)
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
