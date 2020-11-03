//
//  RatingFeedbackModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class RatingFeedbackModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    let feedback: String?
    let averageValue: String?
    let team: QDMTeam?

    // MARK: - Init
    init(team: QDMTeam?, feedback: String?, averageValue: String?, domainModel: QDMDailyBriefBucket?) {
        self.feedback = feedback
        self.averageValue = averageValue
        self.team = team
        super.init(domainModel)
    }
}
