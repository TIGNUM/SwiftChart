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

    private let syncStateObserver: SyncStateObserver
    let services: Services

    init(services: Services) {
        self.services = services
        self.syncStateObserver = SyncStateObserver(realm: services.mainRealm)
    }

    func setItemCompleted(guideID: String, completion: ((Error?) -> Void)? = nil) {
        do {
            let completedDate = Date()
            let realm = services.mainRealm
            let id = try GuideItemID(stringRepresentation: guideID)
            if id.kind == .notification, let item = realm.syncableObject(ofType: RealmGuideItemNotification.self, remoteID: id.remoteID) {
                try realm.write {
                    item.completedAt = completedDate
                    item.didUpdate()
                    completion?(nil)
                }
            } else if id.kind == .learn, let item = realm.syncableObject(ofType: RealmGuideItemLearn.self, remoteID: id.remoteID) {
                try realm.write {
                    item.completedAt = completedDate
                    item.didUpdate()
                    completion?(nil)
                }
            }
        } catch {
            log(error, level: .error)
            completion?(error)
        }
    }

    var hasSyncedNecessaryItems: Bool {
        return syncStateObserver.hasSynced(RealmGuideItemLearn.self)
            && syncStateObserver.hasSynced(RealmGuideItemNotification.self)
    }
}
