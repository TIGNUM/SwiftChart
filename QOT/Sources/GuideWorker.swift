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
        let learnItems = services.guideItemLearnService.items().map { RealmGuideItem(itemLearn: $0) }
        let notificationItems = services.guideItemNotificationService.todayItems().map {
            return RealmGuideItem(itemNotification: $0)
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
            let predicate = NSPredicate(guideID: guideID)
            let guideItem = realm.objects(RealmGuideItem.self).filter(predicate).first

            if let itemLearn = guideItem?.guideItemLearn {
                try realm.write {
                    itemLearn.completedAt = completedDate
                    guideItem?.completedAt = completedDate
                    completion?(nil)
                }
            } else if let itemNotification = guideItem?.guideItemNotification {
                try realm.write {
                    itemNotification.completedAt = completedDate
                    guideItem?.completedAt = completedDate
                    completion?(nil)
                }
            }
        } catch {
            log(error, level: .error)
            completion?(error)
        }
    }
}
