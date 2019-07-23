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

    enum ToBeVision: String {
        case intro = "tbv-generator-key-intro"
        case instructions = "tbv-generator-key-instructions"
        case home = "tbv-generator-key-home"
        case work = "tbv-generator-key-work"
        case next = "tbv-generator-key-next"
        case create = "tbv-generator-key-create"
        case picture = "tbv-generator-key-picture"
        case review = "tbv-generator-key-review"
    }

    enum MindsetShifter: String {
        case intro = "mindsetshifter-key-intro"
        case openTBV = "mindsetshifter-open-tbv"
        case showTBV = "mindsetshifter-show-tbv"
        case check = "mindsetshifter-check-plan"
        case moreInfo = "mindsetshifter-key-moreinfo"
        case gutReactions = "mindsetshifter-key-gut-reactions"
        case lowSelfTalk = "mindset-low-impact-self-talk"
        case lowPerformanceTalk = "mindsetshifter-key-low-performance-talk"
    }

    enum MindsetShifterTBV: String {
        case intro = "mindsetshifter-tbv-generator-key-intro"
        case work = "mindsetshifter-tbv-generator-key-work"
        case home = "mindsetshifter-tbv-generator-key-home"
        case review = "mindsetshifter-tbv-generator-key-review"
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

    enum Solve: String {
        case intro = "solve-key-intro"
        case help = "solve-key-help"
        case sleepDeprivation = "solve-key-sleep-deprivation"
    }

    enum Recovery: String {
        case intro = "3drecovery-question-intro"
        case syntom = "3drecovery-question-syntom"
        case loading = "3drecovery-question-generate-recovery-loading"
    }

    enum Sprint: String {
        case intro = "sprint-key-intro"
        case introContinue = "sprint-key-intro-continue"
        case selection = "sprint-key-sprint-selection"
        case schedule = "sprint-key-schedule"
        case last = "sprint-key-last-question"
    }

    struct SprintReflection {
        static let Intro = "sprint-post-reflection-key-intro"
        static let Notes01 = "sprint-post-reflection-key-notes-01"
        static let Notes02 = "sprint-post-reflection-key-notes-02"
        static let Notes03 = "sprint-post-reflection-key-notes-03"
        static let Review = "sprint-post-reflection-key-review"
    }
}
