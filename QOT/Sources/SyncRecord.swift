//
//  SyncRecord.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

enum SyncType: String {
    case contentCategoryDown
    case contentCollectionDown
    case contentItemDown
    case userDown

    var endpoint: Endpoint {
        switch self {
        case .contentCategoryDown: return .contentCategories
        case .contentCollectionDown: return .contentCollection
        case .contentItemDown: return .contentItems
        case .userDown: return .user
        }
    }
}

final class SyncRecord: Object {

    private(set) dynamic var type: String = ""

    /// Date as milliseconds since Epoch time
    private(set) dynamic var date: Int64 = 0

    // MARK: Realm

    override class func primaryKey() -> String? {
        return "type"
    }

    // MARK: Initializers

    convenience init(type: SyncType, date: Int64) {
        self.init()

        self.type = type.rawValue
        self.date = date
    }
}
