//
//  SyncRecord.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

final class SyncRecord: Object {

    private(set) dynamic var associatedClassName: String = ""

    /// Date as milliseconds since Epoch time
    private(set) dynamic var date: Int64 = 0

    // MARK: Realm

    override class func primaryKey() -> String? {
        return "associatedClassName"
    }

    // MARK: Initializers

    convenience init(associatedClassName: String, date: Int64) {
        self.init()

        self.associatedClassName = associatedClassName
        self.date = date
    }
}
