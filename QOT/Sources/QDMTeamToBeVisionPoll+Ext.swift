//
//  QDMTeamToBeVisionPoll+Ext.swift
//  QOT
//
//  Created by karmic on 02.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMTeamToBeVisionPoll {
    var remainingDays: Int {
        return Date().days(to: endDate ?? Date())
    }

    var showBatch: Bool {
        switch (creator, userDidVote, open) {
        case (false, false, true): return true
        case (true, _, true): return true
        default: return false
        }
    }

    var shouldShowPollExplanation: Bool {
        switch (creator, userDidVote, open) {
        case (true, _, true): return false
        default: return true
        }
    }

    var shouldShowPollAdmin: Bool {
        switch (creator, userDidVote, open) {
        case (true, _, true): return true
        default: return false
        }
    }
}
