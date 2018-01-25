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

    private let realm: Realm
    private let realmProvider: RealmProvider

    init(realm: Realm, realmProvider: RealmProvider) {
        self.realm = realm
        self.realmProvider = realmProvider
    }

    func background() throws -> GuideService {
        return GuideService(realm: try realmProvider.realm(), realmProvider: realmProvider)
    }

    func setNotificationItemComplete(remoteID: Int, date: Date) throws {
        let type = RealmGuideItemNotification.self
        guard let item = realm.syncableObject(ofType: type, remoteID: remoteID) else { return }

        try realm.write {
            item.completedAt = date
            item.didUpdate()
        }
    }

    func setLearnItemComplete(remoteID: Int, date: Date) throws {
        let type = RealmGuideItemLearn.self
        guard let item = realm.syncableObject(ofType: type, remoteID: remoteID) else { return }

        try realm.write {
            item.completedAt = date
            item.didUpdate()
        }
    }

    func learnItems() -> Results<RealmGuideItemLearn> {
        return realm.objects(RealmGuideItemLearn.self)
    }

    func notificationItems() -> Results<RealmGuideItemNotification> {
        return realm.objects(RealmGuideItemNotification.self)
    }

    func eraseGuide() throws {
        try realm.write {
            realm.delete(realm.objects(RealmGuideItem.self))
            realm.delete(realm.objects(RealmGuideItemLearn.self))
            realm.delete(realm.objects(RealmGuideItemNotification.self))
        }
    }
}
