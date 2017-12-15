//
//  GuideItemNotificationService.swift
//  QOT
//
//  Created by karmic on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class GuideItemNotificationService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func items() -> AnyRealmCollection<GuideItemNotification> {
        return AnyRealmCollection(mainRealm.objects(GuideItemNotification.self))
    }

    func nextItems(day: Int, type: GuideItemNotification.ItemType) -> AnyRealmCollection<GuideItemNotification> {
        return mainRealm.guideItemsLearn(day: day, type: type)
    }

    func todayItems() -> List<GuideItemNotification> {
        let items = Array(mainRealm.objects(GuideItemNotification.self)) as [GuideItemNotification]
        let todayNotifications = items.filter { $0.issueDate.isSameDay(Date()) }

        return List<GuideItemNotification>(todayNotifications)
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

    func eraseItems() {
        do {
            try mainRealm.write {
                mainRealm.delete(mainRealm.objects(GuideItemNotification.self))
            }
        } catch {
            assertionFailure("Failed to delete GuideItemsNotification with error: \(error)")
        }
    }
}

private extension Realm {

    func guideItemsLearn(day: Int, type: GuideItemNotification.ItemType) -> AnyRealmCollection<GuideItemNotification> {
        let predicate = NSPredicate(format: "ANY type == %@ AND day == %d", type.rawValue, day)
        return anyCollection(.priorityOrder(), predicates: predicate)
    }
}
