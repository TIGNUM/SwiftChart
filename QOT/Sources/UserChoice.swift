//
//  UserChoice.swift
//  QOT
//
//  Created by Sam Wyndham on 12.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class UserChoice: SyncableObject {

    fileprivate let _contentCategoryID = RealmOptional<Int>()

    fileprivate let _contentCollectionID = RealmOptional<Int>()

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

    convenience init(contentCategoryID: Int, contentCollectionID: Int, startDate: Date, endDate: Date) {
        self.init()

        self._contentCategoryID.value = contentCategoryID
        self._contentCollectionID.value = contentCollectionID
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension UserChoice: DownSyncable {

    func setData(_ data: UserChoiceIntermediary, objectStore: ObjectStore) throws {
        type = data.type
        userText = data.userText
        startDate = data.startDate
        endDate = data.endDate
        _contentCategoryID.value = data.contentCategoryID
        _contentCollectionID.value = data.contentCollectionID
    }
}
