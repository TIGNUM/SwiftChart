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
    let teamNames: [String]?
    let teamInvitations: [QDMTeamInvitation]?

    // MARK: - Init
    init(title: String,
         teamOwner: String?,
         teamNames: [String]?,
         teamInvitations: [QDMTeamInvitation]?,
         image: String?,
         domainModel: QDMDailyBriefBucket?) {
        self.teamOwner = teamOwner
        self.teamNames = teamNames
        self.teamInvitations = teamInvitations
        let inviteCount = teamNames?.count
        let multipleTeamsBody = AppTextService.get(.daily_brief_team_invitation_multiple_teams_subtitle)
            .replacingOccurrences(of: "${first_team}", with: (String(describing: teamNames?.first ?? String.empty)))
            .replacingOccurrences(of: "${remaining_teams_count}", with: String((inviteCount ?? 0) - 1))
        let singleTeamBody = AppTextService.get(.daily_brief_single_team_invitation_subtitle)
            .replacingOccurrences(of: "${admin}", with: teamOwner ?? String.empty)
            .replacingOccurrences(of: "${team}", with: teamNames?.first ?? String.empty)

        let body = (inviteCount ?? 0) > 1 ? multipleTeamsBody : singleTeamBody
        super.init(domainModel,
                   caption: AppTextService.get(.daily_brief_team_invitation_title_new),
                   title: title,
                   body: body,
                   image: image)
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
