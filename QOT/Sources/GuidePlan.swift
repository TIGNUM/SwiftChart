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

    let planID: String = ""

    let greeting: String = ""

    let planingTime: String  = ""

    let planDay: String = ""

    let learnItems = List<GuidePlanItemLearn>()

    let notificationItems = List<GuidePlanItemNotification>()

}

extension GuidePlan {

    static var endPoint: Endpoint {
        return .guidePlan
    }
}
