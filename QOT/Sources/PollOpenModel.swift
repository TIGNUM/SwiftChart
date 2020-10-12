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
    let teamName: String?
    let teamColor: UIColor?

    // MARK: - Init
    init(teamName: String?, teamAdmin: String?, teamColor: UIColor?, domainModel: QDMDailyBriefBucket?) {
        self.teamName = teamName
        self.teamAdmin = teamAdmin
        self.teamColor = teamColor
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? PollOpenModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            teamName == source.teamName &&
            teamAdmin == source.teamAdmin &&
            teamColor == source.teamColor
    }
}
