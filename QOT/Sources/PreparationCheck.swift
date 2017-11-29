//
//  PreparationStep.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class PreparationCheck: SyncableObject {

    // MARK: Public Properties

    @objc private(set) dynamic var preparationID: Int = 0

    @objc private(set) dynamic var contentItemID: Int = 0

    @objc dynamic var covered: Date? // A date indicates the time it was checked and nil indicates it is unchecked

    @objc dynamic var deleted: Bool = false

    @objc dynamic var changeStamp: String? = UUID().uuidString

    // MARK: - Relationships

    @objc private(set) dynamic var preparation: Preparation?

    @objc private(set) dynamic var contentItem: ContentItem?

    // MARK: Functions

    convenience init(preparation: Preparation?, contentItem: ContentItem?, covered: Date?) {
        self.init()
        self.preparation = preparation
        if let preparationID = contentItem?.remoteID.value {
            self.preparationID = preparationID
        }
        self.contentItem = contentItem
        if let contentItemID = contentItem?.remoteID.value {
            self.contentItemID = contentItemID
        }
        self.covered = covered
    }

    func delete() {
        if let realm = realm {
            if remoteID.value == nil {
                realm.delete(self)
            } else {
                deleted = true
                dirty = true
            }
        }
    }
}

// MARK: - BuildRelations

extension PreparationCheck: BuildRelations {

    func buildRelations(realm: Realm) {
        guard let preparation = realm.syncableObject(ofType: Preparation.self, remoteID: preparationID) else {
            return
        }
        self.preparation = preparation
        contentItem = realm.syncableObject(ofType: ContentItem.self, remoteID: contentItemID)
    }
}

// MARK: - TwoWaySyncable

extension PreparationCheck: TwoWaySyncable {

    func setData(_ data: PreparationCheckIntermediary, objectStore: ObjectStore) throws {
        preparationID = data.preparationID
        contentItemID = data.contentItemID
        covered = data.covered
    }

    static var endpoint: Endpoint {
        return .userPreparationCheck
    }

    func toJson() -> JSON? {
        guard syncStatus != .clean else {
            return nil
        }

        let dateFormatter = DateFormatter.iso8601
        var coveredString: String? = nil
        if let covered = covered {
            coveredString = dateFormatter.string(from: covered)
        }
        let dict: [JsonKey: JSONEncodable] = [
            .id: remoteID.value.toJSONEncodable,
            .createdAt: dateFormatter.string(from: createdAt),
            .modifiedAt: dateFormatter.string(from: modifiedAt),
            .qotId: localID,
            .syncStatus: syncStatus.rawValue,
            .userPreparationId: (preparation?.remoteID.value ?? nil).toJSONEncodable,
            .contentId: (contentItem?.remoteID.value ?? nil).toJSONEncodable,
            .contentItemId: contentItemID,
            .covered: coveredString.toJSONEncodable
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
