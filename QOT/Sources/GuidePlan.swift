//
//  Guide.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class GuidePlan: SyncableObject {

    @objc private(set) dynamic var planID: String = ""

    @objc private(set) dynamic var greeting: String = ""

    let learnItems = List<GuidePlanItemLearn>()

    let notificationItems = List<GuidePlanItemNotification>()

}

extension GuidePlan {

    static var endPoint: Endpoint {
        return .guidePlan
    }
}
