//
//  UserNotificationsManager.swift
//  QOT
//
//  Created by Sam Wyndham on 25/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications

final class UserNotificationsManager {

    private let realmProvider: RealmProvider
    private lazy var scheduler = UserNotificationsScheduler(center: UNUserNotificationCenter.current(),
                                                            calendar: Calendar.current)
    private let guideItemBlockDeterminer = GuideLearnItemBlockDeterminer(localCalendar: Calendar.current)

    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
        scheduler.onChange { [weak self] (notificationIDs) in
            self?.updateScheduledStates(pendingNofiticationIDs: notificationIDs)
        }
    }

    func scheduleNotifications() {
        NotificationConfigurationObject.scheduleDailyNotificationsIfNeeded()
        do {
            let now = Date()
            let realm = try realmProvider.realm()
            let notificationItems = realm.objects(RealmGuideItemNotification.self).filter {
                guard $0.completedAt == nil, let triggerDate = $0.localNotificationDate else { return false }
                return triggerDate >= now
            }
            let learnItems = realm.objects(RealmGuideItemLearn.self)
            let featureItems = todaysLearnItems(from: learnItems, type: .feature, now: now)
            let strategyItems = todaysLearnItems(from: learnItems, type: .strategy, now: now)
            let notificationItemRequests = notificationItems.compactMap { $0.notificationRequest }
            var requests: [UNNotificationRequest] = []
            requests.append(contentsOf: notificationItems.compactMap { $0.notificationRequest })
            requests.append(contentsOf: featureItems.compactMap({ $0.notificationRequest }))
            requests.append(contentsOf: strategyItems.compactMap({ $0.notificationRequest }))
            let notificationItemRequestsIDs = Array(notificationItemRequests.compactMap { $0.identifier })
            removeNotifications(withIdentifiers: notificationItemRequestsIDs) { [weak self] in
                self?.scheduler.scheduleNotifications(requests)
            }
        } catch {
            log("Error scheduling notifications: \(error)", level: .error)
        }
    }

    func removeNotifications(withIdentifiers identifiers: [String], completion: (() -> Void)?) {
        scheduler.removeNotifications(withIdentifiers: identifiers, completion: completion)
    }

    private func updateScheduledStates(pendingNofiticationIDs: Set<String>) {
        let scheduledIDs: [Int] = pendingNofiticationIDs.compactMap {
            if let id = try? GuideItemID(stringRepresentation: $0), id.kind == .notification {
                return id.remoteID
            }
            return nil
        }
        do {
            let now = Date()
            let realm = try realmProvider.realm()
            let notificationItems = realm.objects(RealmGuideItemNotification.self).filter {
                guard $0.completedAt == nil, let triggerDate = $0.localNotificationDate else {
                    return false
                }
                return triggerDate >= now
            }
            try realm.write {
                for notificationItem in notificationItems {
                    let isLocallyScheduled = scheduledIDs.contains(notificationItem.forcedRemoteID)
                    if isLocallyScheduled != notificationItem.localNofiticationScheduled {
                        notificationItem.localNofiticationScheduled = isLocallyScheduled
                        notificationItem.didUpdate()
                    }
                }
            }
        } catch {
            log("Error updating scheduled states: \(error)", level: .error)
        }
    }

    private func todaysLearnItems(from allItems: Results<RealmGuideItemLearn>,
                                  type: RealmGuideItemLearn.ItemType,
                                  now: Date) -> [RealmGuideItemLearn] {
        let typedItems = allItems.filter { $0.type == type.rawValue }
        guard let block = guideItemBlockDeterminer.todaysBlockIndex(for: Array(typedItems), now: now) else { return [] }
        return typedItems.filter {
            guard $0.completedAt == nil, let triggerDate = $0.localNotificationDate, $0.block == block else {
                return false
            }
            return triggerDate >= now
        }
    }
}
