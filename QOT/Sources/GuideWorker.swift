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

    let services: Services

    init(services: Services) {
        self.services = services
    }

    func createTodaysGuide() -> RealmGuide {
        let learnItems = services.guideItemLearnService.items().map { RealmGuideItem(item: $0, date: Date()) }
        let notificationItems = services.guideItemNotificationService.todayItems().map {
            return RealmGuideItem(item: $0, date: Date())
        }

        var guideItems: [RealmGuideItem] = []
        guideItems.append(contentsOf: learnItems)
        guideItems.append(contentsOf: notificationItems)
        let sorted = guideItems.sorted { (lhs: RealmGuideItem, rhs: RealmGuideItem) -> Bool in
            return lhs.priority > rhs.priority
        }
        return services.guideService.createGuide(items: sorted)
    }

    func setItemCompleted(guideID: String, completion: ((Error?) -> Void)? = nil) {
        do {
            let completedDate = Date()
            let realm = services.mainRealm
            if let guideItem = realm.object(ofType: RealmGuideItem.self, forPrimaryKey: guideID),
                let referencedItem = guideItem.referencedItem {
                try realm.write {
                    referencedItem.completedAt = completedDate
                    guideItem.completedAt = completedDate
                    guideItem.didUpdate()
                    completion?(nil)
                }
            }
        } catch {
            log(error, level: .error)
            completion?(error)
        }
    }
}

private extension GuideWorker {

    func addLearnItemNotifications() {
        let learnItems = services.guideItemLearnService.items()
        let localNotificationsBuilder = LocalNotificationBuilder(realmProvider: services.realmProvider)
        localNotificationsBuilder.addLearnItemNotifications(learnItems: learnItems)
    }
}
