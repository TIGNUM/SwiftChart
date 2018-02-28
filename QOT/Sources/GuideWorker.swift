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
    let backgroudQueue = DispatchQueue(label: "guide worker", qos: .background)

    init(services: Services) {
        self.services = services
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
        let learnItems = services.guideService.learnItems()
        let notificationItems = services.guideService.notificationItems()
        let featureItems = learnItems.filter { $0.type == RealmGuideItemLearn.ItemType.feature.rawValue }
        let strategyItems = learnItems.filter { $0.type == RealmGuideItemLearn.ItemType.strategy.rawValue }
        let guideGenerator = GuideGenerator(maxDays: 3, factory: itemFactory)

        do {
            let guide = try guideGenerator.generateGuide(notificationItems: Array(notificationItems),
                                                         featureItems: Array(featureItems),
                                                         strategyItems: Array(strategyItems))
            completion(guide)
        } catch {
            log("Unable to generate guide: \(error)", level: .error)
        }
    }

    private var hasSyncedNecessaryItems: Bool {
        return syncStateObserver.hasSynced(RealmGuideItemLearn.self)
            && syncStateObserver.hasSynced(RealmGuideItemNotification.self)
            && syncStateObserver.hasSynced(UserAnswer.self)
    }
}
