//
//  DTMindset.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Mindset {
    struct QuestionKey {
        static let Intro = "mindsetshifter-key-intro"
        static let OpenTBV = "mindsetshifter-open-tbv"
        static let ShowTBV = "mindsetshifter-show-tbv"
        static let Check = "mindsetshifter-check-plan"
        static let MoreInfo = "mindsetshifter-key-moreinfo"
        static let GutReactions = "mindsetshifter-key-gut-reactions"
        static let LowSelfTalk = "mindset-low-impact-self-talk"
        static let LowPerformanceTalk = "mindsetshifter-key-low-performance-talk"
        static let Last = "mindsetshifter-last-question"
    }

    struct AnswerKey {
        static let ShowTBV = "mindsetshifter-answer-key-show-tbv"
        static let CheckPlan = "mindsetshifter-answer-key-check-plan"
    }

    struct Filter {
        static let Relationship = "_relationship_"
        static let TriggerRelationship = "trigger_relationship_"
        static let Reaction = "-reaction-"
        static let Trigger = "-trigger-"
        static let LowPerfomance = "-lowperformance-"
    }
}
