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

protocol RealmGuideItemProtocol: class {

    var remoteID: RealmOptional<Int> { get }
    var completedAt: Date? { get set }
    var priority: Int { get }
    var displayTime: RealmGuideTime? { get }
}

final class RealmGuideItem: SyncableObject {

    @objc dynamic var guideItemLearn: RealmGuideItemLearn?

    @objc dynamic var guideItemNotification: RealmGuideItemNotification?

    @objc dynamic var completedAt: Date?

    @objc dynamic var changeStamp: String? = UUID().uuidString

    convenience init(item: RealmGuideItemLearn, date: Date) {
        self.init()
        self.guideItemLearn = item
        self.completedAt = item.completedAt
        self.localID = GuideItemID(date: date, item: item).stringRepresentation
    }

    convenience init(item: RealmGuideItemNotification, date: Date) {
        self.init()
        self.guideItemNotification = item
        self.completedAt = item.completedAt
        self.localID = GuideItemID(date: date, item: item).stringRepresentation
    }
}

extension RealmGuideItem {

    var priority: Int {
        return referencedItem?.priority ?? 0
    }

    var referencedItem: RealmGuideItemProtocol? {
        if let guideItemLearn = guideItemLearn {
            return guideItemLearn
        } else if let guideItemNotification = guideItemNotification {
            return guideItemNotification
        } else {
            return nil
        }
    }

    var displayTime: RealmGuideTime? {
        return referencedItem?.displayTime
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
            let isLearnItem = (object.referencedItem as? RealmGuideItemLearn) != nil
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
        guard let id = referencedItem?.remoteID.value else { return nil }

        let dateFormatter = DateFormatter.iso8601
        let completedAtString = completedAt.map { dateFormatter.string(from: $0) }

        var dict: [JsonKey: JSONEncodable] = [
            .id: id,
            .createdAt: dateFormatter.string(from: createdAt),
            .completedAt: completedAtString.toJSONEncodable
        ]

        if let notificationItem = referencedItem as? RealmGuideItemNotification, notificationItem.displayTime != nil {
            if completedAt != nil || notificationItem.displayTime != nil {
                dict[.serverPush] = false
            }
        }
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
