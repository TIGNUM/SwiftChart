//
//  TeamInvitationModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamInvitationModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    let teamOwner: String?
    let teamNames: [String?]

    // MARK: - Init
    init(teamOwner: String?, teamNames: [String?], domainModel: QDMDailyBriefBucket?) {
        self.teamOwner = teamOwner
        self.teamNames = teamNames
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
           guard let source = source as? TeamInvitationModel else {
               return false
           }
           return super.isContentEqual(to: source) &&
               teamOwner == source.teamOwner &&
               teamNames == source.teamNames
       }
}
