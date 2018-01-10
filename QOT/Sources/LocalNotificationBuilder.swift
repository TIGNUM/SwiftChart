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
import UIKit

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
                if let notificationDate = itemNotification.localNotificationDate,
                    let issueDate = itemNotification.issueDate {
                    self.create(notification: itemNotification,
                                notificationDate: notificationDate,
                                issueDate: issueDate)
                }
            }
        }
    }

    func addLearnItemNotification(for item: RealmGuideItemLearn, identifier: String) {
        if let notificationDate = item.localNotificationDate {
            print("addLearnItemNotification", item.type)
            create(itemLearn: item, identifier: identifier, notificationDate: notificationDate)
        }
    }

    static func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func updateNotification(identifier: String, triggerDate: Date, content: UNNotificationContent) {
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger(triggerDate))
        addNotification(request: request)
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

    func create(notification: RealmGuideItemNotification, notificationDate: Date, issueDate: Date) {
        let identifier = GuideItemID(date: issueDate, item: notification).stringRepresentation
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content(title: notification.title,
                                                             body: notification.body,
                                                             sound: notification.sound,
                                                             link: notification.link),
                                            trigger: trigger(notificationDate))
        addNotification(request: request)
    }

    func create(itemLearn: RealmGuideItemLearn, identifier: String, notificationDate: Date) {
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content(title: itemLearn.title,
                                                             body: itemLearn.body,
                                                             sound: itemLearn.sound,
                                                             link: itemLearn.link),
                                            trigger: trigger(notificationDate))
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
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour], from: issueDate)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    }

    func addNotification(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                log(error, level: .error)
            }
        }
    }
}
