//
//  RateOpenModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class RateOpenModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    let team: QDMTeam?
    let ownerEmail: String?

    // MARK: - Init
    init(team: QDMTeam?, ownerEmail: String?, domainModel: QDMDailyBriefBucket?) {
        self.team = team
        self.ownerEmail = ownerEmail
        super.init(domainModel)
    }
}
