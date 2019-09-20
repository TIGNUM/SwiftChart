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
    var solveModels: [SolveViewModel]

    struct SolveViewModel {
        var title: String?
        var date: String?
        var solve: QDMSolve?

        init() {}

        init(title: String?,
             date: String?,
             solve: QDMSolve?,
             domainModel: QDMDailyBriefBucket) {
            self.title = title
            self.date = date
            self.solve = solve
        }
    }

    // MARK: - Init
    init(bucketTitle: String?, twoDayAgo: String?, question1: String?, question2: String?, question3: String?, solveModels: [SolveViewModel], domainModel: QDMDailyBriefBucket?) {
        self.bucketTitle = bucketTitle
        self.twoDayAgo = twoDayAgo
        self.question1 = question1
        self.question2 = question2
        self.question3 = question3
        self.solveModels = solveModels
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? SolveReminderCellViewModel else { return false }
        return super.isContentEqual(to: source) &&
            bucketTitle == source.bucketTitle &&
            twoDayAgo == source.twoDayAgo &&
            domainModel?.sprint?.doneForToday == source.domainModel?.sprint?.doneForToday
    }
}
