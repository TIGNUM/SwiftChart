//
//  GuideWorker.swift
//  QOT
//
//  Created by karmic on 15.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class GuideWorker {

    private let syncStateObserver: SyncStateObserver
    let services: Services
    let widgetDataManager: WidgetDataManager
    let backgroudQueue = DispatchQueue(label: "guide worker", qos: .background)

    init(services: Services) {
        self.services = services
        self.widgetDataManager = WidgetDataManager(services: services)
        self.syncStateObserver = SyncStateObserver(realm: services.mainRealm)
    }

    func setItemCompleted(id: GuideItemID) {
        backgroudQueue.async {
            do {
                let service = try self.services.guideService.background()
                let now = Date()
                switch id.kind {
                case .learn:
                    try service.setLearnItemComplete(remoteID: id.remoteID, date: now)
                case .notification:
                    try service.setNotificationItemComplete(remoteID: id.remoteID, date: now)
                }

                self.services.userNotificationsManager.removeNotifications(withIdentifiers: [id.stringRepresentation])
            } catch {
                log("Failed to set item completed: \(error)", level: .error)
            }
        }
    }

    func makeGuide(completion: (Guide.Model?) -> Void) {
        guard hasSyncedNecessaryItems == true else {
            completion(nil)
            return
        }

        // FIXME: We don't really want to do this on the main thread but the objects we use are using main thread
        let itemFactory = GuideItemFactory(services: services)
        let toBeVisionItem = itemFactory.makeToBeVisionItem()
        let whatsHotItems = itemFactory.makeWhatsHotItem()
		let learnItems = services.guideService.learnItems()
        let allNotificationItems = services.guideService.notificationItems()
        // FIXME: Remove filter when server no longer returns daily prep type notification items
        let notificationItems = allNotificationItems.filter("type != 'MORNING_INTERVIEW' AND type != 'WEEKLY_INTERVIEW'")
        let featureItems = learnItems.filter { $0.type == RealmGuideItemLearn.ItemType.feature.rawValue }
        let strategyItems = learnItems.filter { $0.type == RealmGuideItemLearn.ItemType.strategy.rawValue }
        let guideGenerator = GuideGenerator(maxDays: guideMaxDays, factory: itemFactory)
        let notificationConfigurations = NotificationConfigurationObject.all()
        let preparations = services.preparationService.preparations()

        // Filter daily prep results so there is only one for each day
        let dailyPrepResults = services.mainRealm.objects(DailyPrepResultObject.self)
            .reduce([:]) { (results, object) -> [String: DailyPrepResultObject] in
            var results = results
            if let existing = results[object.isoDate] {
                if existing.remoteID.value == nil {
                    results[object.isoDate] = object
                }
            } else {
                results[object.isoDate] = object
            }
            return results
        }

        do {
            let guide = try guideGenerator.generateGuide(toBeVisionItem: toBeVisionItem,
														 whatsHotItems: whatsHotItems,
                                                         notificationItems: Array(notificationItems),
                                                         featureItems: Array(featureItems),
                                                         strategyItems: Array(strategyItems),
                                                         notificationConfigurations: notificationConfigurations,
                                                         dailyPrepResults: Array(dailyPrepResults.values),
                                                         preparations: Array(preparations))
            completion(guide)
            widgetDataManager.update(.all)
        } catch {
            log("Unable to generate guide: \(error)", level: .error)
        }
    }

    func markWhatsHotRead(item: Guide.Item) {
        services.contentService.setContentCollectionViewed(localID: item.identifier)
    }

    private var hasSyncedNecessaryItems: Bool {
        return syncStateObserver.hasSynced(RealmGuideItemLearn.self)
            && syncStateObserver.hasSynced(RealmGuideItemNotification.self)
            && syncStateObserver.hasSynced(Question.self)
            && syncStateObserver.hasSynced(DailyPrepResultObject.self)
    }
}
