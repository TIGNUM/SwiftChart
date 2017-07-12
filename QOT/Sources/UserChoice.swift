//
//  UserChoice.swift
//  QOT
//
//  Created by Sam Wyndham on 12.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class UserChoice: Object {

    fileprivate let _contentCategoryID = RealmOptional<Int>()

    fileprivate let _contentCollectionID = RealmOptional<Int>()

    dynamic var localID: String = UUID().uuidString

    dynamic var remoteID: Int = -1

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    fileprivate(set) dynamic var dirty: Bool = true

    fileprivate(set) dynamic var type: String = ""

    fileprivate(set) dynamic var userText: String?

    fileprivate(set) dynamic var startDate: Date = Date()

    fileprivate(set) dynamic var endDate: Date = Date()

    var contentCategoryID: Int? {
        return _contentCategoryID.value
    }

    var contentCollectionID: Int? {
        return _contentCollectionID.value
    }

    override class func primaryKey() -> String? {
        return "localID"
    }

    convenience init(contentCategoryID: Int, contentCollectionID: Int, startDate: Date, endDate: Date) {
        self.init()

        self._contentCategoryID.value = contentCategoryID
        self._contentCollectionID.value = contentCollectionID
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension UserChoice: DownSyncable {

    static func make(remoteID: Int, createdAt: Date) -> UserChoice {
        let choice = UserChoice()
        choice.remoteID = remoteID
        choice.createdAt = createdAt
        return choice
    }

    func setData(_ data: UserChoiceIntermediary, objectStore: ObjectStore) throws {
        type = data.type
        userText = data.userText
        startDate = data.startDate
        endDate = data.endDate
        _contentCategoryID.value = data.contentCategoryID
        _contentCollectionID.value = data.contentCollectionID
    }
}
