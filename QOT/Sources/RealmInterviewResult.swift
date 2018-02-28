//
//  RealmMorningInterviewResult.swift
//  QOT
//
//  Created by Sam Wyndham on 15/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmInterviewResult: Object {

    @objc private(set) dynamic var notificationRemoteID: Int = 0

    @objc dynamic var feedback: String?

    override class func primaryKey() -> String? {
        return "notificationRemoteID"
    }

    convenience init(notificationRemoteID: Int) {
        self.init()

        self.notificationRemoteID = notificationRemoteID
    }
}
