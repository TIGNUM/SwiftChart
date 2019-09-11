//
//  UserNotificationsManager.swift
//  QOT
//
//  Created by Sam Wyndham on 25/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import UserNotifications
import qot_dal

final class UserNotificationsManager {
    static private var _main: UserNotificationsManager?
    static public var main: UserNotificationsManager {
        if _main == nil {
            _ = ContentService.main
            _ = UserService.main
            _main = UserNotificationsManager()
        }
        return _main!
    }
    private let queue = DispatchQueue(label: "UserNotificationsManager", qos: .background)

    init() {
        // listen Sprint Up/Down, GuideItemNotification Down
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userLogout(_:)),
                                               name: .userLogout, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFinishSynchronization(_:)),
                                               name: .didFinishSynchronization, object: nil)
    }

    func scheduleNotifications() {
        let dispatchGroup = DispatchGroup()

        // schedule new notifications
        let now = Date()
        var requests = [UNNotificationRequest]()
        var scheduledNotificationItems = [QDMGuideItemNotfication]()
        dispatchGroup.enter()
        NotificationService.main.getGuideNotifications { (items, initiated, error) in
            guard let items = items, initiated == true, error == nil else {
                dispatchGroup.leave()
                return
            }
            let futureRequests = items.filter { $0.localNotificationDate ?? now > now }
            requests.append(contentsOf: futureRequests.compactMap({ $0.notificationRequest }))
            scheduledNotificationItems.append(contentsOf: futureRequests)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        var sprintNotificationConfig = [QDMSprintNotificationConfig]()
        NotificationService.main.getSprintNotificationConfigs { (items, initiated, error) in
            guard let items = items, initiated == true, error == nil else {
                dispatchGroup.leave()
                return
            }
            sprintNotificationConfig = items
            dispatchGroup.leave()
        }

        var currentSprint: QDMSprint?
        dispatchGroup.enter()
        UserService.main.getSprints { (sprints, initiated, error) in
            guard let sprints = sprints, initiated == true, error == nil else {
                dispatchGroup.leave()
                return
            }
            currentSprint = sprints.filter({ $0.isInProgress }).first
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: queue) {
            self._scheduleNotifciations(currentSprint, sprintNotificationConfig, requests)
            NotificationService.main.reportScheduledNotification(scheduledNotificationItems) { (error) in }
        }
    }
    private func _scheduleNotifciations(_ currentSprint: QDMSprint?,
                                        _ sprintNotificationConfig: [QDMSprintNotificationConfig],
                                        _ requests: [UNNotificationRequest]) {
        NotificationConfigurationObject.scheduleDailyNotificationsIfNeeded()
        self.removeDuplicatedNotificationAndCreateNotificationsFor(currentSprint, sprintNotificationConfig, requests) { (requests) in
            guard let newRequests = requests, newRequests.isEmpty == false else {
                return
            }
            let notificationCenter = UNUserNotificationCenter.current()

            // remove Delivered Notifications which it has same link in the future
            notificationCenter.getDeliveredNotifications(completionHandler: { (deliveredNotifications) in
                var identifiersToRemove = [String]()
                for deliveredNotification in deliveredNotifications {
                    for newRequest in requests ?? [] {
                        guard let link = newRequest.content.link() else { continue }
                        if deliveredNotification.request.content.link() == link {
                            identifiersToRemove.append(deliveredNotification.request.identifier)
                        }
                    }
                }
                notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiersToRemove)
            })
            notificationCenter.getPendingNotificationRequests(completionHandler: { (pendingNotifications) in
                let pendingNotificaionIds = pendingNotifications.compactMap({ $0.identifier })
                let allValidFutureNotificationIds = newRequests.compactMap({ $0.identifier })
                let finalRequests = newRequests.filter({ pendingNotificaionIds.contains(obj: $0.identifier) == false })
                // Schedule new Notifications
                if finalRequests.isEmpty == false {
                    notificationCenter.scheduleNofications(finalRequests, queue: self.queue, completion: { (requests) in })
                }

                // Remove Pending notifications which are not valid any more.
                let pendingNotificationIdsToRemove = pendingNotificaionIds.filter({
                    if allValidFutureNotificationIds.contains(obj: $0) || $0.contains(DAILY_CHECK_IN_NOTIFICATION_IDENTIFIER) {
                        return false
                    }
                    return true
                })
                if pendingNotificationIdsToRemove.isEmpty == false {
                    notificationCenter.removePendingNotificationRequests(withIdentifiers: pendingNotificationIdsToRemove)
                }
            })
        }
    }
    private func removeDuplicatedNotificationAndCreateNotificationsFor(_ sprint: QDMSprint?,
                                                                       _ config: [QDMSprintNotificationConfig]?,
                                                                       _ originalRequests: [UNNotificationRequest]?,
                                                                       _ completion: @escaping ([UNNotificationRequest]?) -> Void) {
        var requests = originalRequests ?? []
        guard let sprint = sprint,
            let config = config, config.isEmpty == false else {
                self.removeAllSprintRelatedPendingNotifications()
                completion(requests)
                return
        }
        guard let sprintType = sprint.sprintCollection?.searchTagsDetailed
            .filter({ $0.name != nil && $0.name != "SPRINT_REPORT" }).first?.name else {
                self.removeAllSprintRelatedPendingNotifications()
                completion(requests)
                return
        }
        guard let sprintConfig = config.filter({ $0.sprintType == sprintType}).first else {
            self.removeAllSprintRelatedPendingNotifications()
            completion(requests)
            return
        }

        // schedule for today and tomorrow.
        // if user doesn't open the app, sprint should be paused automatically
        let days: [Int] = [0, 1]
        let dispatchGroup = DispatchGroup()
        var notificationTagsToRemove = [Date: [String]]()
        dispatchGroup.enter()
        for day in days {
            let dayForSprintConfig = day + sprint.currentDay
            guard let notificationSchedule = sprintConfig.notificationSchedule?.filter({ $0.day == dayForSprintConfig }).first else {
                continue
            }
            guard let excludeNotificationTags = notificationSchedule.excludedNotification,
                let sprintContentTags = notificationSchedule.contentTags else {
                    continue
            }

            notificationTagsToRemove[Date().dateAfterDays(day)] = excludeNotificationTags
            dispatchGroup.enter()
            ContentService.main.getContentCollectionsWith(tags: sprintContentTags) { (sprintContents) in
                if let content = sprintContents?.first,
                    let notificationTitle = content.contentItems.filter({ $0.format == .title }).first?.valueText,
                    let notificationText = content.contentItems.filter({ $0.format == .paragraph }).first?.valueText,
                    let triggerDate = notificationSchedule.date(with: Date().dayAfter(days: day)), triggerDate > Date() {
                    // if it's valid sprint notification for today
                    let content = UNMutableNotificationContent(title: notificationTitle, body: notificationText, soundName: "", link: "")
                    content.sound = nil
                    let trigger = UNCalendarNotificationTrigger(localTriggerDate: triggerDate)
                    let identifier = QDMGuideItemNotfication.notificationIdentifier(with: sprintConfig.sprintType,
                                                                                    date: triggerDate,
                                                                                    link: "qot://daily-brief?bucketName=sprint")
                    requests.append(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.leave()

        dispatchGroup.notify(queue: queue) {
            var requestIdetifiersToRemove = [String]()
            let filteredRequests = requests.filter { (request) -> Bool in
                for date in notificationTagsToRemove.keys {
                    if request.nextTriggerDate()?.isSameDay(date) == false {
                        return true
                    }
                    for excludeTag in notificationTagsToRemove[date] ?? [] {
                        if request.identifier.contains(excludeTag) {
                            requestIdetifiersToRemove.append(request.identifier)
                            return false
                        }
                    }
                }
                return true
            }
            if requestIdetifiersToRemove.isEmpty == false {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestIdetifiersToRemove)
            }
            completion(filteredRequests)
        }
    }

    private func removeAllSprintRelatedPendingNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests(completionHandler: { (pendingNotifications) in
            let pendingSprintNotificaionIds = pendingNotifications.compactMap({ $0.identifier })
                .filter({ $0.hasPrefix("SPRINT_") })
            if pendingSprintNotificaionIds.isEmpty == false {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: pendingSprintNotificaionIds)
            }
        })
    }
}

extension UserNotificationsManager {
    @objc func userLogout(_ notification: Notification) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    @objc func didFinishSynchronization(_ notification: Notification) {
        guard let syncResult = notification.object as? SyncResultContext, syncResult.dataType == .SPRINT else { return }
        scheduleNotifications()
    }
}
