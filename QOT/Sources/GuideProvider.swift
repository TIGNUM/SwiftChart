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

    var onUpdate: ((Guide.Model) -> Void)?

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
        let itemFactory = GuideItemFactory(services: services)
        let featureItems = learnItems.filter { $0.type == RealmGuideItemLearn.ItemType.feature.rawValue }
        let strategyItems = learnItems.filter { $0.type == RealmGuideItemLearn.ItemType.strategy.rawValue }
        let guideScheduleGenerator = GuideScheduleGenerator(maxDays: 3, factory: itemFactory)

        do {
            let guide = try guideScheduleGenerator.generateSchedule(notificationItems: Array(notificationItems),
                                                               featureItems: Array(featureItems),
                                                               strategyItems: Array(strategyItems))
            onUpdate?(guide)
        } catch {
            log("Unable to generate guide: \(error)", level: .error)
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
