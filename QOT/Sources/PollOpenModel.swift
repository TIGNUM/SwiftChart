//
//  PollOpenModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class PollOpenModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    let teamAdmin: String?
    let team: QDMTeam?

    // MARK: - Init
    init(team: QDMTeam?, teamAdmin: String?, domainModel: QDMDailyBriefBucket?) {
        self.teamAdmin = teamAdmin
        self.team = team
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? PollOpenModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            teamAdmin == source.teamAdmin
    }
}
