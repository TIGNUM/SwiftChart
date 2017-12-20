//
//  RealmGuideInteration.swift
//  QOT
//
//  Created by Sam Wyndham on 20.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy
import RealmSwift

final class RealmGuideInteraction: SyncableObject {

    @objc private(set) dynamic var itemType: String = ""

    @objc private(set) dynamic var itemID: Int = 0

    @objc private(set) dynamic var completedAt: Date?

    @objc private(set) dynamic var serverPush: Bool = false

    convenience init(item: RealmGuideItemLearn) {
        self.init()
        self.itemType = ItemType.learn.rawValue
        self.itemID = item.remoteID.value ?? 0
        self.completedAt = item.completedAt
    }

    convenience init(item: RealmGuideItemNotification, serverPush: Bool) {
        self.init()
        self.itemType = ItemType.notification.rawValue
        self.itemID = item.remoteID.value ?? 0
        self.completedAt = item.completedAt
        self.serverPush = serverPush
    }
}

private enum ItemType: String {

    case learn
    case notification
}

extension RealmGuideInteraction: UpSyncable {

    static var endpoint: Endpoint {
        return .guide
    }

    var syncStatus: UpSyncStatus {
        return .createdLocally
    }

    static var dirtyPredicate: NSPredicate {
        return NSPredicate(format: "TRUEPREDICATE")
    }

    static func upSyncData(realm: RealmProvider) throws -> UpSyncData? {
        let realm = try realm.realm()
        let items = objectsAndJSONs(realm: realm)
        if items.count == 0 {
            return nil
        }

        let completions = items.map { (object, _) -> (LocalIDToRemoteIDMap, Realm) -> Void in
            let localID = object.localID
            return { (map: LocalIDToRemoteIDMap, realm: Realm) in
                if let object = realm.syncableObject(ofType: RealmGuideInteraction.self, localID: localID) {
                    realm.delete(object)
                }
            }
        }

        var learnJSONs: [JSON] = []
        var notificationJSONs: [JSON] = []
        for (object, json) in items {
            guard let itemType = ItemType(rawValue: object.itemType) else { continue }

            switch itemType {
            case .learn:
                learnJSONs.append(json)
            case .notification:
                notificationJSONs.append(json)
            }
        }
        let json = JSON.dictionary([
            JsonKey.learnItems.rawValue: learnJSONs.toJSON(),
            JsonKey.notificationItems.rawValue: notificationJSONs.toJSON()
        ])
        return UpSyncData(body: try json.serialize()) { (localIDtoRemoteIDMap, realm) in
            completions.forEach { $0(localIDtoRemoteIDMap, realm) }
        }
    }

    func toJson() -> JSON? {
        guard let itemType = ItemType(rawValue: itemType) else { return nil }

        let dateFormatter = DateFormatter.iso8601
        let completedAtString = completedAt.map { dateFormatter.string(from: $0) }

        var dict: [JsonKey: JSONEncodable] = [
            .id: itemID,
            .createdAt: dateFormatter.string(from: createdAt),
            .completedAt: completedAtString.toJSONEncodable
        ]
        if itemType == .notification {
            dict[.serverPush] = serverPush
        }

        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
