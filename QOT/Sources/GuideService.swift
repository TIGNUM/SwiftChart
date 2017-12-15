//
//  GuideService.swift
//  QOT
//
//  Created by karmic on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class GuideService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func createGuide(learnItems: List<GuideItemLearn>,
                     notificationItems: List<GuideItemNotification>,
                     guideItemService: GuideItemService) -> Guide {
        let items = createItems(learnItems: learnItems,
                                notificationItems: notificationItems,
                                guideItemService: guideItemService)
        let guide = Guide()
        guide.items = items

        do {
            try mainRealm.write {
                mainRealm.add(guide)
            }
        } catch {
            log(error)
        }

        return guide
    }

    private func createItems(learnItems: List<GuideItemLearn>,
                             notificationItems: List<GuideItemNotification>,
                             guideItemService: GuideItemService) -> List<GuideItem> {
        var guideItems = [GuideItem]()

        do {
            try learnItems.forEach { (learnItem: GuideItemLearn) in
                let item = try guideItemService.createGuideItem(itemID: learnItem.remoteID.value ?? 0,
                                                            title: learnItem.title,
                                                            body: learnItem.body,
                                                            type: learnItem.body,
                                                            typeDisplayString: learnItem.type,
                                                            greeting: learnItem.greeting,
                                                            link: learnItem.link,
                                                            priority: learnItem.priority,
                                                            block: learnItem.block,
                                                            issueDate: nil,
                                                            displayTime: learnItem.displayTime,
                                                            reminderTime: learnItem.reminderTime,
                                                            completedAt: nil)
                guideItems.append(item)
            }

            try notificationItems.forEach { (notificationItem: GuideItemNotification) in
                let item = try guideItemService.createGuideItem(itemID: notificationItem.remoteID.value ?? 0,
                                                            title: notificationItem.title ?? "",
                                                            body: notificationItem.body,
                                                            type: notificationItem.type,
                                                            typeDisplayString: notificationItem.type,
                                                            greeting: notificationItem.greeting ?? "",
                                                            link: notificationItem.link,
                                                            priority: notificationItem.priority,
                                                            block: 0,
                                                            issueDate: notificationItem.issueDate,
                                                            displayTime: notificationItem.displayTime,
                                                            reminderTime: notificationItem.reminderTime,
                                                            completedAt: nil)
                guideItems.append(item)
            }
        } catch {
            log(error)
        }

        let sortedItems = guideItems.sorted { (lhs: GuideItem, rhs: GuideItem) -> Bool in
            return lhs.priority > rhs.priority
        }

        return List<GuideItem>(sortedItems)
    }

    func todaysGuide() -> Guide? {
        return guideSections().filter { (guide: Guide) -> Bool in
            return guide.createdAt.isSameDay(Date())
        }.first
    }

    func guideSections() -> AnyRealmCollection<Guide> {
        return AnyRealmCollection(mainRealm.objects(Guide.self))
    }

    func eraseGuide() {
        do {
            try mainRealm.write {
                mainRealm.delete(guideSections())
            }
        } catch {
            assertionFailure("Failed to delete toBeVision with error: \(error)")
        }
    }
}
