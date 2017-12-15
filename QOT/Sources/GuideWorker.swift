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

    let serivces: Services

    init(services: Services) {
        self.serivces = services
    }

    func createTodaysGuide() -> Guide {
        let learnItems = serivces.guideItemLearnService.items().map { GuideItem(itemLearn: $0) }
        let notificationItems = serivces.guideItemNotificationService.todayItems().map {
            return GuideItem(itemNotification: $0)
        }
        var guideItems: [GuideItem] = []
        guideItems.append(contentsOf: learnItems)
        guideItems.append(contentsOf: notificationItems)
        let sorted = guideItems.sorted { (lhs: GuideItem, rhs: GuideItem) -> Bool in
            return lhs.priority > rhs.priority
        }
        return serivces.guideService.createGuide(items: sorted)
    }
}
