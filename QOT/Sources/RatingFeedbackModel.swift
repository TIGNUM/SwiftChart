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
    let teamName: String?
    let feedback: String?
    let averageValue: Double?
    let teamColor: UIColor?

    // MARK: - Init
    init(teamName: String?, feedback: String?, averageValue: Double?, teamColor: UIColor?, domainModel: QDMDailyBriefBucket?) {
        self.teamName = teamName
        self.feedback = feedback
        self.averageValue = averageValue
        self.teamColor = teamColor
        super.init(domainModel)
    }
}
