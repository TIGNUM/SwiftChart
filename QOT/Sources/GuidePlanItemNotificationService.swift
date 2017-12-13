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

    func nextItems(day: Int, type: GuidePlanItemNotification.ItemType) -> AnyRealmCollection<GuidePlanItemNotification> {
        return mainRealm.guidePlanItemsLearn(day: day, type: type)
    }

    func todayItems() -> List<GuidePlanItemNotification> {
        let plans = Array(mainRealm.objects(GuidePlanItemNotification.self)) as [GuidePlanItemNotification]

        let notifications = plans.filter { (guidePlan: GuidePlanItemNotification) -> Bool in
            return guidePlan.createdAt.isSameDay(Date())
        }

        return List<GuidePlanItemNotification>(notifications)
    }

    func setItemCompleted(item: GuidePlanItemNotification) {
        do {
            try mainRealm.write {
                item.completed = true
            }
        } catch let error {
            assertionFailure("Set item completed: \(GuidePlanItemNotification.self), error: \(error)")
        }
    }

    func eraseItem(item: GuidePlanItemNotification) {
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

    func guidePlanItemsLearn(day: Int, type: GuidePlanItemNotification.ItemType) -> AnyRealmCollection<GuidePlanItemNotification> {
        let predicate = NSPredicate(format: "ANY type == %@ AND day == %d", type.rawValue, day)
        return anyCollection(.priorityOrder(), predicates: predicate)
    }
}
