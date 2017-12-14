//
//  GuidePlanItemNotificationService.swift
//  QOT
//
//  Created by karmic on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class GuidePlanItemNotificationService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func nextItems(day: Int, type: GuideItemNotification.ItemType) -> AnyRealmCollection<GuideItemNotification> {
        return mainRealm.guidePlanItemsLearn(day: day, type: type)
    }

    func todayItems() -> List<GuideItemNotification> {
        let plans = Array(mainRealm.objects(GuideItemNotification.self)) as [GuideItemNotification]

        let notifications = plans.filter { (guidePlan: GuideItemNotification) -> Bool in
            return guidePlan.createdAt.isSameDay(Date())
        }

        return List<GuideItemNotification>(notifications)
    }

    func setItemCompleted(item: GuideItemNotification) {
        do {
            try mainRealm.write {
                item.completed = true
            }
        } catch let error {
            assertionFailure("Set item completed: \(GuideItemNotification.self), error: \(error)")
        }
    }

    func eraseItem(item: GuideItemNotification) {
        do {
            try mainRealm.write {
                mainRealm.delete(item)
            }
        } catch {
            assertionFailure("Failed to delete GuidePlanItemLearn with error: \(error)")
        }
    }
}

private extension Realm {

    func guidePlanItemsLearn(day: Int, type: GuideItemNotification.ItemType) -> AnyRealmCollection<GuideItemNotification> {
        let predicate = NSPredicate(format: "ANY type == %@ AND day == %d", type.rawValue, day)
        return anyCollection(.priorityOrder(), predicates: predicate)
    }
}
