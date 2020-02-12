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

let DEBUG_LOCAL_NOTIFICATION_IDENTIFIER = "DEBUG_LOCAL_NOTIFICATION_IDENTIFIER"
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
    private let notificationCenter = UNUserNotificationCenter.current()
    private var isScheduling = false
    private var needToSchedule = false
    init() {
        // listen Sprint Up/Down, GuideItemNotification Down
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userLogout(_:)),
                                               name: .userLogout, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFinishSynchronization(_:)),
                                               name: .didFinishSynchronization, object: nil)
    }

    func removeAll() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }

    func getDailyCheckInLocalNotificationConfigruations(_ completion: @escaping ([DailyCheckInLocalNotificationConfig]) -> Void) {
        SettingService.main.getSettingFor(key: .DailyCheckInLocalNotifidationConfiguration) { (setting, _, _) in
            var configs: [DailyCheckInLocalNotificationConfig] = Array(1...7).compactMap({ /// create default config
                DailyCheckInLocalNotificationConfig(weekday: $0)
            })
            if let json = setting?.textValue, let jsonData = json.data(using: .utf8) {
                do { /// update config from setting
                    configs = try JSONDecoder().decode([DailyCheckInLocalNotificationConfig].self, from: jsonData)
                } catch {
                    log("failed to get Daily check in local notification configuration", level: .error)
                }
            }
            completion(configs)
        }
    }

    func scheduleNotifications() {
        guard isScheduling == false else {
            needToSchedule = true
            return
        }
        self.notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.isScheduling = true
                self.getDailyCheckInLocalNotificationConfigruations { (configs) in
                    self._scheduleNotifications(with: configs)
                }
            default: break
            }
        }
    }

    func _scheduleNotifications(with dailyCheckInNotificationConfigs: [DailyCheckInLocalNotificationConfig]) {
        let dispatchGroup = DispatchGroup()

        // schedule new notifications
        let now = Date()
        var requests = [UNNotificationRequest]()
        var scheduledNotificationItems = [QDMGuideItemNotification]()
        dispatchGroup.enter()
        NotificationService.main.getGuideNotifications { (items, initiated, error) in
            guard let items = items, initiated == true, error == nil else {
                dispatchGroup.leave()
                return
            }
            let futureRequests = items.filter { $0.localNotificationDate ?? now > now }
            requests.append(contentsOf: futureRequests.compactMap({ $0.notificationRequest }))
            scheduledNotificationItems.append(contentsOf: futureRequests)
            // report scheduled guide item notifications
            NotificationService.main.reportScheduledLocalNotification(futureRequests) { (_) in /* WOW */ }
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
            let yesterday = Date().dateAfterDays(-1).beginingOfDate()
            let today = Date().beginingOfDate()
            // valid sprint : is in progress, is completed today or is completed yesterday
            currentSprint = sprints.filter({ $0.isInProgress }).first ??
                sprints.filter({ $0.completedDays == $0.maxDays && $0.completedAt?.beginingOfDate() == today }).first ??
                sprints.filter({ $0.completedAt?.beginingOfDate() == yesterday }).first
            dispatchGroup.leave()
        }

        var preparationNotificationContents = [String]()
        let PEAKPERFORMANCE_NOTIFICATION_CONTENT_ID = 102437
        dispatchGroup.enter()
        ContentService.main.getContentCollectionById(PEAKPERFORMANCE_NOTIFICATION_CONTENT_ID) { (content) in
            preparationNotificationContents = content?.contentItems.compactMap({ $0.valueText }) ?? []
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        var ciriticalPreparations = [QDMUserPreparation]()
        UserService.main.getUserPreparations { (preparations, initialized, error) in
            guard let preparations = preparations, initialized == true, error == nil else {
                dispatchGroup.leave()
                return
            }
            ciriticalPreparations = preparations.filter({
                guard $0.type == .LEVEL_CRITICAL, let eventDate = $0.eventDate else { return false }
                return eventDate > Date().dayAfter(days: 1)
            })
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            let preparationNotificationRequests = ciriticalPreparations.compactMap({
                $0.notificationRequest(with: preparationNotificationContents.shuffled().first ?? "")
            })
            // report scheduled preparation notifications
            for request in preparationNotificationRequests {
                guard let link = request.content.link() else { continue }
                NotificationService.main.reportScheduledLocalNotification(identifier: nil,
                                                                          internalNotificationIdentifier: request.identifier,
                                                                          link: link) { (_) in /* WOW */ }
            }
            requests.append(contentsOf: preparationNotificationRequests)
            self._scheduleNotifications(currentSprint, sprintNotificationConfig, requests, dailyCheckInNotificationConfigs)
        }
    }

    private func _scheduleNotifications(_ currentSprint: QDMSprint?,
                                        _ sprintNotificationConfig: [QDMSprintNotificationConfig],
                                        _ requests: [UNNotificationRequest],
                                        _ dailyCheckInNotificationConfigs: [DailyCheckInLocalNotificationConfig]) {
        notificationCenter.getPendingNotificationRequests(completionHandler: { (requests) in
            let pendingIdeintifiers = requests.compactMap({ $0.identifier })
            for config in dailyCheckInNotificationConfigs {
                if pendingIdeintifiers.contains(config.identifier()) == false {
                    scheduleDailycheckInNotification(config: config)
                }
            }
        })
        self.createSprintNotifications(currentSprint, sprintNotificationConfig, requests) { (requests, identifiersToRemove) in
            guard let newRequests = requests, newRequests.isEmpty == false else {
                return
            }
            // report scheduled sprint notifications
            for request in newRequests {
                guard let link = request.content.link() else { continue }
                NotificationService.main.reportScheduledLocalNotification(identifier: nil,
                                                                          internalNotificationIdentifier: request.identifier,
                                                                          link: link) { (_) in /* WOW */ }
            }
            let notificationCenter = UNUserNotificationCenter.current()

            // remove Delivered Notifications which it has same link in the future
            notificationCenter.getDeliveredNotifications(completionHandler: { (deliveredNotifications) in
                var deliveredIdentifiersToRemove = [String]()
                for deliveredNotification in deliveredNotifications {
                    for newRequest in requests ?? [] {
                        guard let link = newRequest.content.link() else { continue }
                        if deliveredNotification.request.content.link() == link {
                            deliveredIdentifiersToRemove.append(deliveredNotification.request.identifier)
                        }
                    }
                }
                self.queue.async {
                    notificationCenter.removeDeliveredNotifications(withIdentifiers: deliveredIdentifiersToRemove)
                }
            })
            notificationCenter.getPendingNotificationRequests(completionHandler: { (pendingNotifications) in
                let pendingNotificaionIds = pendingNotifications.compactMap({ $0.identifier })
                var allValidFutureNotificationIds = newRequests.compactMap({ $0.identifier })
                allValidFutureNotificationIds.append(contentsOf: dailyCheckInNotificationConfigs.compactMap({
                    $0.identifier()
                }))
                let finalRequests = newRequests.filter({ pendingNotificaionIds.contains(obj: $0.identifier) == false })

                // Remove Pending notifications which are not valid any more.
                var pendingNotificationIdsToRemove = pendingNotificaionIds.filter({
                    if allValidFutureNotificationIds.contains(obj: $0) || $0.contains(DEBUG_LOCAL_NOTIFICATION_IDENTIFIER) {
                        return false
                    }
                    return true
                })
                pendingNotificationIdsToRemove.append(contentsOf: identifiersToRemove)

                if pendingNotificationIdsToRemove.isEmpty == false {
                    self.queue.async {
                        notificationCenter.removePendingNotificationRequests(withIdentifiers: pendingNotificationIdsToRemove)
                    }
                }
                notificationCenter.getPendingNotificationRequests(completionHandler: { (requests) in
                    // Schedule new Notifications
                    self.queue.async {
                        for request in finalRequests {
                            notificationCenter.add(request) { (error) in
                                if let error = error {
                                    log("Failed to schedule user notification request: \(request), error: \(error)")
                                }
                            }
                        }
                        if self.needToSchedule {
                            DispatchQueue.main.async {
                                self.scheduleNotifications()
                            }
                        }
                        self.needToSchedule = false
                        self.isScheduling = false
                    }
                })
            })
        }
    }

    private func createSprintNotifications(_ sprint: QDMSprint?,
                                           _ config: [QDMSprintNotificationConfig]?,
                                           _ originalRequests: [UNNotificationRequest]?,
                                           _ completion: @escaping ([UNNotificationRequest]?, [String]) -> Void) {
        var requests = originalRequests ?? []
        guard let sprint = sprint,
            let config = config, config.isEmpty == false else {
                completion(requests, [])
                return
        }
        guard let sprintType = sprint.sprintCollection?.searchTagsDetailed
            .filter({ $0.name != nil && $0.name != "SPRINT_REPORT" }).first?.name else {
                completion(requests, [])
                return
        }
        guard let sprintConfig = config.filter({ $0.sprintType == sprintType}).first else {
            completion(requests, [])
            return
        }

        // schedule for today and tomorrow.
        // if user doesn't open the app, sprint should be paused automatically in 5 days
        let days: [Int] = [0, 1]
        let dispatchGroup = DispatchGroup()
        var notificationTagsToRemove = [Date: [String]]()
        dispatchGroup.enter()
        for day in days {
            let dayForSprintConfig = day + sprint.currentDay
            guard let notificationSchedule = sprintConfig.notificationSchedule?.filter({ $0.day == dayForSprintConfig }).first else {
                continue
            }
            guard let sprintContentTags = notificationSchedule.contentTags else {
                continue
            }

            notificationTagsToRemove[Date().dateAfterDays(day)] = notificationSchedule.excludedNotification
            dispatchGroup.enter()
            ContentService.main.getContentCollectionsWith(tags: sprintContentTags) { (sprintContents) in
                if let content = sprintContents?.first,
                    let notificationText = content.contentItems.filter({ $0.format == .paragraph }).first?.valueText,
                    let triggerDate = notificationSchedule.date(with: Date().dayAfter(days: day)), triggerDate > Date() {
                    let notificationTitle = content.contentItems.filter({ $0.format == .title }).first?.valueText ?? sprint.title
                    // if it's valid sprint notification for today
                    let link = URLScheme.dailyBrief.launchPathWithParameterValue(DailyBriefBucketName.SPRINT_CHALLENGE)
                    let content = UNMutableNotificationContent(title: notificationTitle,
                                                               body: notificationText,
                                                               soundName: "QotNotification.aiff",
                                                               link: link)
                    let trigger = UNCalendarNotificationTrigger(localTriggerDate: triggerDate)
                    let identifier = QDMGuideItemNotification.notificationIdentifier(with: sprintConfig.sprintType,
                                                                                    date: triggerDate,
                                                                                    link: link)
                    requests.append(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.leave()

        dispatchGroup.notify(queue: .main) {
            var requestIdentifiersToRemove = [String]()
            let filteredRequests = requests.filter { (request) -> Bool in
                for date in notificationTagsToRemove.keys {
                    if request.nextTriggerDate()?.isSameDay(date) == false {
                        return true
                    }
                    for excludeTag in notificationTagsToRemove[date] ?? [] {
                        if request.identifier.contains(excludeTag) {
                            requestIdentifiersToRemove.append(request.identifier)
                            return false
                        }
                    }
                }
                return true
            }
            completion(filteredRequests, requestIdentifiersToRemove)
        }
    }
}

extension UserNotificationsManager {
    @objc func userLogout(_ notification: Notification) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    @objc func didFinishSynchronization(_ notification: Notification) {
        let dataTypes: [SyncDataType] = [.SPRINT, .LOCAL_NOTIFICATION, .NONE]
        guard let syncResult = notification.object as? SyncResultContext,
            dataTypes.contains(obj: syncResult.dataType) else { return }
        scheduleNotifications()
    }
}
