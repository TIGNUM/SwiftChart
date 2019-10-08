//
//  DTSolve.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Solve {
    struct QuestionKey {
        static let Intro = "solve-key-intro"
        static let Help = "solve-key-help"
        static let SleepDeprivation = "solve-key-sleep-deprivation"
        static let Nutrition = "solve-key-nutrition"
        static let MovementPlan = "solve-key-movement-plan"
        static let Ready = "solve-key-ready"
        static let Dive = "solve-key-dive"
        static let DiveNutritionMindset = "solve-key-dive-nutrition-mindset"
        static let BackFromShortTBV = "back-from-short-tbv"
        static let TBVNextSteps = "solve-tbv-next-steps"
    }

    struct AnswerKey {
        static let OpenTBV = "solve-open-tbv"
        static let LetsDoIt = "solve-lets-do-it"
        static let OpenVisionPage = "open-vision-page"
        static let OpenResult = "open_result_view"
    }

    struct QuestionTargetId {
        static let ReviewTBV = 100356
        static let PostCreationShortTBV = 100385
    }
}
