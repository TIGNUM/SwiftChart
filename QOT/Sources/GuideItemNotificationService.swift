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

    func items() -> AnyRealmCollection<RealmGuideItemNotification> {
        return AnyRealmCollection(mainRealm.objects(RealmGuideItemNotification.self))
    }

    func nextItems(day: Int, type: RealmGuideItemNotification.ItemType) -> AnyRealmCollection<RealmGuideItemNotification> {
        return mainRealm.guideItemsLearn(day: day, type: type)
    }

    func todayItems() -> List<RealmGuideItemNotification> {
        let items = Array(mainRealm.objects(RealmGuideItemNotification.self)) as [RealmGuideItemNotification]
        let todayNotifications = items.filter {
            guard let issueDate = $0.issueDate else { return false }
            return issueDate.isSameDay(Date())
        }

        return List<RealmGuideItemNotification>(todayNotifications)
    }

    func eraseItem(item: RealmGuideItemNotification) {
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
                mainRealm.delete(mainRealm.objects(RealmGuideItemNotification.self))
            }
        } catch {
            assertionFailure("Failed to delete GuideItemsNotification with error: \(error)")
        }
    }
}

private extension Realm {

    func guideItemsLearn(day: Int, type: RealmGuideItemNotification.ItemType) -> AnyRealmCollection<RealmGuideItemNotification> {
        let predicate = NSPredicate(format: "ANY type == %@ AND day == %d", type.rawValue, day)
        return anyCollection(.priorityOrder(), predicates: predicate)
    }
}
