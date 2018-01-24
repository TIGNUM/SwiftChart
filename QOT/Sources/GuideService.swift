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

    func guideIsTotallyCompleted() -> Bool {
        let allLearnItems = mainRealm.objects(RealmGuideItemLearn.self)
        let filtered = allLearnItems.filter { $0.completedAt == nil }

        return filtered.count == 0
    }

    func guideNoneCompleted() -> Bool {
        let allLearnItems = mainRealm.objects(RealmGuideItemLearn.self)
        let filtered = allLearnItems.filter { $0.completedAt != nil }

        return filtered.count == 0
    }
}

// MARK: - Erase

extension GuideService {

    func eraseGuideItems() {
        do {
            try mainRealm.write {
                mainRealm.delete(mainRealm.objects(RealmGuideItem.self))
            }
        } catch {
            assertionFailure("Failed to delete toBeVision with error: \(error)")
        }
    }
}
