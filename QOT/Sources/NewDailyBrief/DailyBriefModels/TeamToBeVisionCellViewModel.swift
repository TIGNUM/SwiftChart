//
//  TeamToBeVisionCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 30.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamToBeVisionCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var teamVision: String?
    var team: QDMTeam?
    var imageURL: String?

    // MARK: - Init
    init(title: String?, teamVision: String?, team: QDMTeam?, imageURL: String?, domainModel: QDMDailyBriefBucket?) {
        self.teamVision = teamVision
        self.team = team
        self.imageURL = imageURL
        super.init(domainModel,
                   caption: title,
                   title: AppTextService.get(.daily_brief_team_to_be_vision_subtitle),
                   body: teamVision,
                   image: imageURL,
                   titleColor: team?.teamColor)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? TeamToBeVisionCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            teamVision == source.teamVision &&
            title == source.title &&
            team?.qotId == source.team?.qotId
    }
}
