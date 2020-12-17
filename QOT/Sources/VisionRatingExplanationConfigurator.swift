//
//  VisionRatingExplanationConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class VisionRatingExplanationConfigurator {
    static func make(team: QDMTeam?, type: Explanation.Types) -> (VisionRatingExplanationViewController) -> Void {
        return { (viewController) in
            requestSynchronization(.TEAM_TO_BE_VISION_GENERATOR_POLL, .DOWN_SYNC)
            requestSynchronization(.TEAM_TO_BE_VISION_TRACKER_POLL, .DOWN_SYNC)
            let presenter = VisionRatingExplanationPresenter(viewController: viewController)
            let interactor = VisionRatingExplanationInteractor(presenter: presenter, team: team, type: type)
            viewController.interactor = interactor
        }
    }
}
