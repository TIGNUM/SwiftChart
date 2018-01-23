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
    var networkManager: NetworkManager? // FIXME: Remove when can

    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }

    func setup() {
        let now = Date()
        let notifications: [RealmGuideItemNotification] = guideNotifications(realmProvider: realmProvider).filter {
            guard let notificationDate = $0.localNotificationDate, notificationDate > now else {
                return false
            }
            return true
            }.sorted { (a, b) -> Bool in
                a.localNotificationDate! > b.localNotificationDate!
        }

        let prefix = Array(notifications.prefix(20)) // FIXME: We need to limit how many. 20 is just a guess.
        cancelServerPush(for: prefix) {
            prefix.forEach { (notification: RealmGuideItemNotification) in
                if let notificationDate = notification.localNotificationDate,
                    let issueDate = notification.issueDate {
                    self.create(notification: notification, notificationDate: notificationDate, issueDate: issueDate)
                }
            }
        }
    }

    func addLearnItemNotification(for item: RealmGuideItemLearn, identifier: String) {
        if let notificationDate = item.localNotificationDate {
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

//    func pendingNotificationIDs(notificationsIDs: [String], completion: @escaping ([String]) -> Void) {
//        queue.async {
//            UNUserNotificationCenter.current().getPendingNotificationRequests { (pendingRequests) in
//                let requestIDs = pendingRequests.map { $0.identifier }
//                let newIDs = notificationsIDs.filter { requestIDs.contains($0) == false }
//                DispatchQueue.main.async {
//                    completion(newIDs)
//                }
//            }
//        }
//    }

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
        let identifier = GuideItemID(item: notification).stringRepresentation
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
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: issueDate)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    }

    func addNotification(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                log(error, level: .error)
            }
        }
    }

    // FIXME: None of the following code belongs here but I need to hack fast to get this working. #Stress

    func cancelServerPush(for notifications: [RealmGuideItemNotification], completion: @escaping () -> Void) {
        guard let networkManager = networkManager else { return }

        let request = StartSyncRequest(from: 0)
        networkManager.request(request, parser: StartSyncResult.parse) { (result) in
            switch result {
            case .success(let startSyncResult):
                let bodyNotifications = notifications.map { CancelNotificationsBody.Notification(id: $0.forcedRemoteID,
                                                                                                 serverPush: false) }
                let body = CancelNotificationsBody(notificationItems: bodyNotifications)
                let encoder = JSONEncoder()
                guard let data = try? encoder.encode(body) else { return }
                let dataString = String(data: data, encoding: .utf8)
                print(dataString!)
                let request = UpSyncRequest(endpoint: .guide, body: data, syncToken: startSyncResult.syncToken)
                networkManager.request(request, parser: UpSyncResultParser.parse) { (upSyncResult) in
                    switch upSyncResult {
                    case .success:
                        completion()
                    case .failure(let error):
                        log("Failed to fetch sync token for cancel server push: \(error)")
                    }
                }
            case .failure(let error):
                log("Failed to fetch sync token for cancel server push: \(error)")
            }
        }
    }
}

private struct CancelNotificationsBody: Encodable {

    struct Notification: Encodable {
        let id: Int
        let serverPush: Bool
    }

    let learnItems: [Int] = [] // Hack for JSON. It is always empty
    let notificationItems: [Notification]
}
