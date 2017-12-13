//
//  GuidePlanService.swift
//  QOT
//
//  Created by karmic on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class GuidePlanService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func planOfToday() -> GuidePlan? {
        let plans = Array(mainRealm.objects(GuidePlan.self)) as [GuidePlan]

        return plans.filter { (guidePlan: GuidePlan) -> Bool in
            return guidePlan.createdAt.isSameDay(Date())
        }.first
    }

    func plans() -> AnyRealmCollection<GuidePlan> {
        let results = mainRealm.objects(GuidePlan.self)

        return AnyRealmCollection(results)
    }

    func learnItems(section: Int) -> List<GuidePlanItemLearn> {
        return plans()[section].learnItems
    }

    func notificationItems(section: Int) -> List<GuidePlanItemNotification> {
        return plans()[section].notificationItems
    }
}
