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

    func planOfToday() -> Guide? {
        let plans = Array(mainRealm.objects(Guide.self)) as [Guide]

        return plans.filter { (guidePlan: Guide) -> Bool in
            return guidePlan.createdAt.isSameDay(Date())
        }.first
    }

    func guideBlocks() -> AnyRealmCollection<Guide> {
        let results = mainRealm.objects(Guide.self)

        return AnyRealmCollection(results)
    }

    func learnItems(section: Int) -> List<GuideItemLearn> {
        return guideBlocks()[section].learnItems
    }

    func notificationItems(section: Int) -> List<GuideItemNotification> {
        return guideBlocks()[section].notificationItems
    }
}
