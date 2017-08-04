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
    
    fileprivate let _contentCategoryID = RealmOptional<Int>()

    fileprivate let _contentCollectionID = RealmOptional<Int>()

    fileprivate(set) dynamic var type: String = ""

    fileprivate(set) dynamic var userText: String?

    fileprivate(set) dynamic var startDate: Date = Date()

    fileprivate(set) dynamic var endDate: Date = Date()

    dynamic var deleted: Bool = false
  
    dynamic var changeStamp: String? = UUID().uuidString
    
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
