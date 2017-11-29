//
//  UserChoice.swift
//  QOT
//
//  Created by Sam Wyndham on 12.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class UserChoice: SyncableObject {
    enum `Type`: String {
        case weekly = "WEEKLY"
        case monthly = "MONTHLY"
    }

    private let _contentCategoryID = RealmOptional<Int>()

    private let _contentCollectionID = RealmOptional<Int>()

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var userText: String?

    @objc private(set) dynamic var startDate: Date = Date()

    @objc private(set) dynamic var endDate: Date = Date()

    @objc dynamic var deleted: Bool = false

    @objc dynamic var changeStamp: String? = UUID().uuidString

    var contentCategoryID: Int? {
        return _contentCategoryID.value
    }

    var contentCollectionID: Int? {
        return _contentCollectionID.value
    }

    convenience init(contentCategoryID: Int, contentCollectionID: Int, startDate: Date, endDate: Date) {
        self.init()

        self._contentCategoryID.value = contentCategoryID
        self._contentCollectionID.value = contentCollectionID
        self.startDate = startDate
        self.endDate = endDate
        self.type = Type.weekly.rawValue
    }

    // FIXME: This should be an actual realm relationship
    var contentCollection: ContentCollection? {
        guard let id = contentCollectionID else {
            return nil
        }
        return realm?.syncableObject(ofType: ContentCollection.self, remoteID: id)
    }
}

extension UserChoice: TwoWaySyncable {

    static var endpoint: Endpoint {
        return .userChoice
    }

    func setData(_ data: UserChoiceIntermediary, objectStore: ObjectStore) throws {
        type = data.type
        userText = data.userText
        startDate = data.startDate
        endDate = data.endDate
        _contentCategoryID.value = data.contentCategoryID
        _contentCollectionID.value = data.contentCollectionID
    }

    func toJson() -> JSON? {
        guard syncStatus != .clean else {
            return nil
        }

        let dateFormatter = DateFormatter.iso8601
        let dict: [JsonKey: JSONEncodable] = [
            .qotId: localID,
            .contentCategoryId: _contentCategoryID.value.toJSONEncodable,
            .contentId: _contentCollectionID.value.toJSONEncodable,
            .startDate: dateFormatter.string(from: startDate),
            .endDate: dateFormatter.string(from: endDate),
            .type: type,
            .ownText: userText.toJSONEncodable,
            .id: remoteID.value.toJSONEncodable
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
