//
//  GuidedStoryModel.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

struct GuidedStory {
    enum State {
        case survey
        case journey
    }

    struct Survey {
        enum QuestionKey: String {
            case intro = "onboarding-survey-intro"
            case last = "onboarding-survey-last-question"
        }
    }
}
