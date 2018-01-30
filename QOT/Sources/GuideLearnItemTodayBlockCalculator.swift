//
//  GuideLearnItemTodayBlockCalculator.swift
//  QOT
//
//  Created by Sam Wyndham on 29/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct GuideLearnItemBlockDeterminer {

    let localCalendar: Calendar

    /**
     Returns the lowest block of an item that is completed today or not completed
     */
    func todaysBlockIndex(for learnItems: [GuideLearnItem], now: Date) -> Int? {
        let todayLocalStartOfDay = localCalendar.startOfDay(for: now)
        var candidate: Int?
        for item in learnItems {
            if let existingCandidate = candidate, existingCandidate <= item.block {
                continue
            }
            if let completedAt =  item.completedAt {
                let localCompletedAt = localCalendar.startOfDay(for: completedAt)
                if localCompletedAt == todayLocalStartOfDay {
                    candidate = item.block
                }
            } else {
                candidate = item.block
            }
        }
        return candidate
    }
}
