//
//  QDMTeamToBeVisionTrackerPoll+Ext.swift
//  QOT
//
//  Created by karmic on 14.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMTeamToBeVisionTrackerPoll {
    var remainingDays: Int {
        return Date().days(to: endDate ?? Date())
    }
}
