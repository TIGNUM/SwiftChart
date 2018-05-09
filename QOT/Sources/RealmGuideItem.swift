//
//  GuideItem.swift
//  QOT
//
//  Created by karmic on 13.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class RealmGuideItem: SyncableObject {

    @objc dynamic var changeStamp: String?

    let notificationItems = LinkingObjects(fromType: RealmGuideItemNotification.self, property: "guideItem")

    let learnItems = LinkingObjects(fromType: RealmGuideItemLearn.self, property: "guideItem")

    convenience init(dirty: Bool) {
        self.init()
        didUpdate()
    }
}

// FIXME: Clean up duplication. This sync doesn't fit our existing methods so we implement again with duplication.
extension RealmGuideItem: UpSyncable, Dirty {

    static var endpoint: Endpoint {
        return .guide
    }

    var syncStatus: UpSyncStatus {
        return dirty ? .updatedLocally : .clean
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "changeStamp != nil")
    }

    static func upSyncData(realm: RealmProvider) throws -> UpSyncData? {
        let realm = try realm.realm()
        let items = objectsAndJSONs(realm: realm)
        if items.count == 0 {
            return nil
        }

        let completions = items.map { (object, _) -> (LocalIDToRemoteIDMap, Realm) throws -> Void in
            let localID = object.localID
            let previousChangeStamp = object.changeStamp
            return { (map: LocalIDToRemoteIDMap, realm: Realm) in
                if let object = realm.syncableObject(ofType: RealmGuideItem.self, localID: localID),
                    previousChangeStamp == object.changeStamp {
                    object.dirty = false
                }
            }
        }

        var learnJSONs: [JSON] = []
        var notificationJSONs: [JSON] = []
        for (object, json) in items {
            let isLearnItem = object.learnItems.count > 0
            if isLearnItem {
                learnJSONs.append(json)
            } else {
                notificationJSONs.append(json)
            }
        }
        let json = JSON.dictionary([
            JsonKey.learnItems.rawValue: learnJSONs.toJSON(),
            JsonKey.notificationItems.rawValue: notificationJSONs.toJSON()
            ])
        return UpSyncData(body: try json.serialize()) { (localIDtoRemoteIDMap, realm) in
            try completions.forEach { try $0(localIDtoRemoteIDMap, realm) }
        }
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    func toJson() -> JSON? {
        let dateFormatter = DateFormatter.iso8601
        var dict: [JsonKey: JSONEncodable] = [:]
        if let notificationItem = notificationItems.first { // There should always be one item {
            let completedAtString = notificationItem.completedAt.map { dateFormatter.string(from: $0) }
            dict[.id] = notificationItem.forcedRemoteID
            dict[.createdAt] = dateFormatter.string(from: notificationItem.createdAt)
            dict[.completedAt] = completedAtString.toJSONEncodable
            dict[.serverPush] = (notificationItem.localNofiticationScheduled == false || notificationItem.completedAt != nil)
        } else if let learnItem = learnItems.first {// There should always be one item  {
            let completedAtString = learnItem.completedAt.map { dateFormatter.string(from: $0) }
            dict[.id] = learnItem.forcedRemoteID
            dict[.createdAt] = dateFormatter.string(from: learnItem.createdAt)
            dict[.completedAt] = completedAtString.toJSONEncodable
        } else {
            return nil
        }
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
