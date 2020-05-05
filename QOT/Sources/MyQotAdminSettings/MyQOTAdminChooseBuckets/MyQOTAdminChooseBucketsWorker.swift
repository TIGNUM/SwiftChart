//
//  MyQOTAdminChooseBucketsWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQOTAdminChooseBucketsWorker {

    var datasource: [(key: DailyBriefBucketName, value: Bool)] = [(key: .DAILY_CHECK_IN_1, value: false),
                                                                  (key: .EXPERT_THOUGHTS, value: false),
                                                                  (key: .MINDSET_SHIFTER, value: false),
                                                                  (key: .DAILY_CHECK_IN_2, value: false),
                                                                  (key: .MY_PEAK_PERFORMANCE, value: false),
                                                                  (key: .EXPLORE, value: false),
                                                                  (key: .SPRINT_CHALLENGE, value: false),
                                                                  (key: .ME_AT_MY_BEST, value: false),
                                                                  (key: .ABOUT_ME, value: false),
                                                                  (key: .SOLVE_REFLECTION, value: false),
                                                                  (key: .GET_TO_LEVEL_5, value: false),
                                                                  (key: .QUESTION_WITHOUT_ANSWER, value: false),
                                                                  (key: .LATEST_WHATS_HOT, value: false),
                                                                  (key: .THOUGHTS_TO_PONDER, value: false),
                                                                  (key: .GOOD_TO_KNOW, value: false),
                                                                  (key: .FROM_MY_COACH, value: false),
                                                                  (key: .FROM_TIGNUM, value: false),
                                                                  (key: .BESPOKE, value: false),
                                                                  (key: .DEPARTURE_INFO, value: false),
                                                                  (key: .LEADERS_WISDOM, value: false),
                                                                  (key: .FEAST_OF_YOUR_EYES, value: false),
                                                                  (key: .WEATHER, value: false),
                                                                  (key: .GUIDE_TRACK, value: false)]
    // MARK: - Init
    init() {
        updateDisplayingBuckets()
    }

    private func updateDisplayingBuckets() {
        let displayingBuckets = DailyBriefService.main.getGeneratedBucketNamesForToday()
        for displayingBucket in displayingBuckets {
            for (index, object) in datasource.enumerated() where object.key == displayingBucket {
                datasource[index].value = true
            }
        }
    }
}
