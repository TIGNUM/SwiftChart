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

    func todaysGuide() -> Guide? {
        return guideBlocks().filter { (guide: Guide) -> Bool in
            return guide.createdAt.isSameDay(Date())
        }.first
    }

    func guideBlocks() -> AnyRealmCollection<Guide> {
        return AnyRealmCollection(mainRealm.objects(Guide.self))
    }
}
