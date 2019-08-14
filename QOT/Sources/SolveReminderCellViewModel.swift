//
//  SolveReminderCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import qot_dal
import Foundation

final class SolveReminderCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var bucketTitle: String?
    var twoDayAgo: String?
    var question1: String?
    var question2: String?
    var question3: String?
    var solveViewModels: [SolveViewModel]

    struct SolveViewModel {
        var title: String?
        var date: String?
        var solve: QDMSolve?
    }

    // MARK: - Init
    init(bucketTitle: String?, twoDayAgo: String?, question1: String?, question2: String?, question3: String?, solveViewModels: [SolveViewModel], domainModel: QDMDailyBriefBucket?) {
    self.bucketTitle = bucketTitle
    self.twoDayAgo = twoDayAgo
    self.question1 = question1
    self.question2 = question2
    self.question3 = question3
    self.solveViewModels = solveViewModels
         super.init(domainModel)
    }
}
