//
//  QuestionKey.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 21.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

// MARK: - Question Key
enum QuestionKey {
    static func maxCharacter(_ key: String?) -> Int {
        switch key {
        case SprintReflection.Notes01,
             SprintReflection.Notes02,
             SprintReflection.Notes03:
            return 250
        case Prepare.BenefitsInput:
            return 100
        default:
            return 0
        }
    }

    struct Prepare {
        static let Intro = "prepare-key-intro"
        static let CalendarEventSelectionDaily = "prepare-key-calendar-event-selection-daily"
        static let CalendarEventSelectionCritical = "prepare-key-calendar-event-selection-critical"
        static let EventTypeSelectionDaily = "prepare-event-type-selection-daily"
        static let EventTypeSelectionCritical = "prepare-event-type-selection-critical"
        static let ShowTBV = "prepare_peak_prep_review_tbv"
        static let BenefitsInput = "prepare_peak_prep_benefits_input"
        static let BuildCritical = "prepare_peak_prep_build_plan"
        static let SelectExisting = "prepare_previous_preps_selection"
    }

    struct SprintReflection {
        static let Intro = "sprint-post-reflection-key-intro"
        static let Notes01 = "sprint-post-reflection-key-notes-01"
        static let Notes02 = "sprint-post-reflection-key-notes-02"
        static let Notes03 = "sprint-post-reflection-key-notes-03"
        static let Review = "sprint-post-reflection-key-review"
    }
}
