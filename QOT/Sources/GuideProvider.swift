//
//  GuideProvider.swift
//  QOT
//
//  Created by Sam Wyndham on 19/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class GuideProvider {

    private let services: Services
    private let syncStateObserver: SyncStateObserver
    private let notificationItems: Results<RealmGuideItemNotification>
    private let learnItems: Results<RealmGuideItemLearn>
    private let becomeActiveHandler = NotificationHandler(name: .UIApplicationDidBecomeActive)
    private var tokenBin = TokenBin()

    var onUpdate: (([Guide.Day]) -> Void)?

    init(services: Services) {
        self.services = services
        self.syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        self.notificationItems = services.guideItemNotificationService.allItems()
        self.learnItems = services.guideItemLearnService.allItems()

        syncStateObserver.onUpdate { [unowned self] _ in
            self.reload()
        }
        becomeActiveHandler.handler = { [unowned self] _ in
            self.reload()
        }
        notificationItems.addNotificationBlock { [unowned self] _ in
            self.reload()
        }.addTo(tokenBin)
        learnItems.addNotificationBlock { [unowned self] _ in
            self.reload()
        }.addTo(tokenBin)
    }

    func reload() {
        let featureItems = learnItems.filter { $0.type == RealmGuideItemLearn.ItemType.feature.rawValue }
        let strategyItems = learnItems.filter { $0.type == RealmGuideItemLearn.ItemType.strategy.rawValue }
        let guideScheduleGenerator = GuideScheduleGenerator(maxDays: 3)
        let schedule = guideScheduleGenerator.generateSchedule(notificationItems: Array(notificationItems),
                                                               featureItems: Array(featureItems),
                                                               strategyItems: Array(strategyItems))
        let days = schedule.map { Guide.Day(day: $0, services: services) }
        onUpdate?(days)
    }
}

extension Guide.Day {

    init(day: GuideScheduleGenerator.Day, services: Services) {
        localStartOfDay = day.localStartOfDay
        items = day.items.flatMap { Guide.Item(item: $0, services: services) }
    }
}

extension Guide.Item {

    init?(item: GuideScheduleGenerator.Item, services: Services) {
        let realm = services.mainRealm
        if RealmGuideItemNotification.ItemType(rawValue: item.type) != nil {
            guard let notification = realm.object(ofType: RealmGuideItemNotification.self, forPrimaryKey: item.id) else {
                return nil
            }
            status = notification.completedAt == nil ? .todo : .done
            title = notification.title ?? ""
            content = .text(notification.body)
            subtitle = notification.displayType
            type = notification.type
            link = .path(notification.link)
            featureLink = nil
            featureButton = nil
            identifier = GuideItemID(item: notification).stringRepresentation
            var interviewResults: [String] = []
            if let interviewResult = notification.interviewResult {
                interviewResults = interviewResult.results.map { String(format: "%d", $0.value) }
            }
            dailyPrep = DailyPrep(questionGroupID: link.groupID,
                                  services: services,
                                  feedback: notification.interviewResult?.feedback,
                                  results: interviewResults)
            greeting = notification.greeting
            createdAt = notification.createdAt
        } else if RealmGuideItemLearn.ItemType(rawValue: item.type) != nil {
            guard let learn = realm.object(ofType: RealmGuideItemLearn.self, forPrimaryKey: item.id) else {
                return nil
            }
            status = learn.completedAt == nil ? .todo : .done
            title = learn.title
            content = .text(learn.body)
            subtitle = learn.displayType ?? ""
            type = learn.type
            link = .path(learn.link)
            featureLink = .path(learn.featureLink ?? "")
            featureButton = learn.featureButton
            identifier = GuideItemID(item: learn).stringRepresentation
            dailyPrep = nil
            greeting = learn.greeting
            createdAt = learn.createdAt
        } else {
            return nil
        }
    }
}

extension RealmGuideItemNotification: GuideNotificationItem {

    var displayAt: (utcDate: Date, hour: Int, minute: Int)? {
        guard let utcDate = issueDate, let hour = displayTime?.hour, let minute = displayTime?.minute else {
            return nil
        }
        return (utcDate: utcDate, hour: hour, minute: minute)
    }
}

extension RealmGuideItemLearn: GuideLearnItem {

    var displayAt: (hour: Int, minute: Int)? {
        guard let hour = displayTime?.hour, let minute = displayTime?.minute else {
            return nil
        }
        return (hour: hour, minute: minute)
    }
}
