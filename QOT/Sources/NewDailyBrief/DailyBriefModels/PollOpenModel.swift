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
    let imageURL: String?

    // MARK: - Init
    init(team: QDMTeam?, teamAdmin: String?, imageURL: String?, domainModel: QDMDailyBriefBucket?) {
        self.teamAdmin = teamAdmin
        self.team = team
        self.imageURL = imageURL
        super.init(domainModel,
                   caption: AppTextService.get(.daily_brief_vision_suggestion_caption).replacingOccurrences(of: "${team}", with: team?.name ?? ""),
                   title: AppTextService.get(.daily_brief_open_poll_title),
                   body: AppTextService.get(.daily_brief_open_poll_text).replacingOccurrences(of: "${admin}", with: teamAdmin ?? ""),
                   image: imageURL,
                   titleColor: team?.teamColor)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? PollOpenModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            teamAdmin == source.teamAdmin
    }
}
