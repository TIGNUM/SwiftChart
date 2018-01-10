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

    func createGuide(items: [RealmGuideItem], date: Date) {
        do {
            let realm = try realmProvider.realm()
            try realm.transactionSafeWrite {
                let key = RealmGuide.dateString(date: date)
                if realm.object(ofType: RealmGuide.self, forPrimaryKey: key) == nil {
                    let guide = RealmGuide(items: List(items), date: date)
                    realm.add(guide)
                }
            }
        } catch {
            log(error, level: .error)
        }
    }

    func todaysGuide() -> RealmGuide? {
        return mainRealm.object(ofType: RealmGuide.self, forPrimaryKey: RealmGuide.dateString(date: Date()))
    }

    func guideSections() -> AnyRealmCollection<RealmGuide> {
        return AnyRealmCollection(mainRealm.objects(RealmGuide.self))
    }
}

// MARK: - Erase

extension GuideService {

    func eraseGuide() {
        do {
            try mainRealm.write {
                mainRealm.delete(guideSections())
            }
        } catch {
            assertionFailure("Failed to delete toBeVision with error: \(error)")
        }
    }

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
