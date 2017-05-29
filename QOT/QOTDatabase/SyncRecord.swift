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

    var endpoint: Endpoint {
        switch self {
        case .contentCategoryDown: return .contentCategories
        }
    }
}

final class SyncRecord: Object {

    private(set) dynamic var type: String = ""

    private(set) dynamic var date: Date = Date()

    // MARK: Realm

    override class func primaryKey() -> String? {
        return "type"
    }

    // MARK: Initializers

    convenience init(type: SyncType, date: Date) {
        self.init()

        self.type = type.rawValue
        self.date = date
    }
}
