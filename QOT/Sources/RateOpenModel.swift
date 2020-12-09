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
    init(team: QDMTeam?, ownerEmail: String?, imageURL: String?, domainModel: QDMDailyBriefBucket?) {
        self.team = team
        self.ownerEmail = ownerEmail
        super.init(domainModel,
                   caption: AppTextService.get(.daily_brief_vision_suggestion_caption).replacingOccurrences(of: "${team}", with: team?.name ?? ""),
                   title: AppTextService.get(.daily_brief_open_rate_title),
                   body: AppTextService.get(.daily_brief_open_rate_body).replacingOccurrences(of: "${admin}", with: ownerEmail ?? ""),
                   image: imageURL,
                   titleColor: team?.teamColor)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? RateOpenModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            ownerEmail == source.ownerEmail &&
            team?.qotId == source.team?.qotId
    }
}
