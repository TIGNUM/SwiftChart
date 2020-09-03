//
//  VisionRatingExplanationModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct Explanation {
    enum Types {
        case ratingOwner
        case ratingUser
        case tbvPollOwner
        case tbvPollUser

        var title: String {
            switch self {
            case .ratingOwner: return AppTextService.get(.my_x_team_tbv_section_rating_explanation_title)
            case .ratingUser: return AppTextService.get(.my_x_team_tbv_section_rating_explanation_member_title)
            case .tbvPollOwner: return AppTextService.get(.team_tbv_poll_title)
            case .tbvPollUser: return AppTextService.get(.team_tbv_poll_title_member)
            }
        }

        var text: String {
            switch self {
            case .ratingOwner: return AppTextService.get(.my_x_team_tbv_section_rating_explanation_text)
            case .ratingUser: return AppTextService.get(.my_x_team_tbv_section_rating_explanation_member_text)
            case .tbvPollOwner: return AppTextService.get(.team_tbv_poll_content)
            case .tbvPollUser: return AppTextService.get(.team_tbv_poll_content_member)
            }
        }

        var videoTitle: String {
            switch self {
            case .ratingOwner,
                 .ratingUser: return AppTextService.get(.my_x_team_tbv_section_rating_explanation_video_title)
            case .tbvPollOwner,
                 .tbvPollUser: return AppTextService.get(.team_tbv_poll_video)
            }
        }
    }
}
