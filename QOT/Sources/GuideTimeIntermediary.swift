//
//  GuideTimeIntermediary.swift
//  QOT
//
//  Created by karmic on 14.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct GuideTimeIntermediary: DownSyncIntermediary {

    let hour: Int
    let minute: Int
    let seconds: Int
    let nano: Int

    init(json: JSON) throws {
        hour = try json .getItemValue(at: .hour, fallback: 0)
        minute = try json .getItemValue(at: .minute, fallback: 0)
        seconds = try json .getItemValue(at: .seconds, fallback: 0)
        nano = try json .getItemValue(at: .nano, fallback: 0)
    }
}
