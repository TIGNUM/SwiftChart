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

    static func continueButtonIsHidden(_ key: String?) -> Bool {
        switch key {
        case QuestionKey.ToBeVision.Instructions,
             QuestionKey.ToBeVision.Review,
             QuestionKey.ToBeVision.Create,
             QuestionKey.ToBeVision.Home,
             QuestionKey.ToBeVision.Work,
             QuestionKey.Prepare.CalendarEventSelectionCritical,
             QuestionKey.Prepare.CalendarEventSelectionDaily,
             QuestionKey.Prepare.ShowTBV:
            return false
        default:
            return true
        }
    }

    static func preiviousButtonIsHidden(_ key: String?) -> Bool {
        switch key {
        case QuestionKey.ToBeVision.Instructions,
             QuestionKey.MindsetShifter.Intro,
             QuestionKey.MindsetShifterTBV.Intro,
             QuestionKey.Prepare.Intro,
             QuestionKey.Solve.Intro,
             QuestionKey.Recovery.intro.rawValue,
             QuestionKey.Sprint.Intro,
             QuestionKey.SprintReflection.Intro:
            return true
        default:
            return false
        }
    }

    struct ToBeVision {
        static let Instructions = "tbv-generator-key-instructions"
        static let Home = "tbv-generator-key-home"
        static let Work = "tbv-generator-key-work"
        static let Create = "tbv-generator-key-create"
        static let Picture = "tbv-generator-key-picture"
        static let Review = "tbv-generator-key-review"
    }

    struct MindsetShifter {
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

    struct MindsetShifterTBV {
        static let Intro = "mindsetshifter-tbv-generator-key-intro"
        static let Work = "mindsetshifter-tbv-generator-key-work"
        static let Home = "mindsetshifter-tbv-generator-key-home"
        static let Review = "mindsetshifter-tbv-generator-key-review"
        static let Learn = "mindsetshifter-tbv-generator-key-learn"
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

    struct Solve {
        static let Intro = "solve-key-intro"
        static let Help = "solve-key-help"
        static let SleepDeprivation = "solve-key-sleep-deprivation"
        static let Nutrition = "solve-key-nutrition"
        static let MovementPlan = "solve-key-movement-plan"
        static let Ready = "solve-key-ready"
        static let Dive = "solve-key-dive"
        static let DiveNutritionMindset = "solve-key-dive-nutrition-mindset"
    }

    enum Recovery: String {
        case intro = "3drecovery-question-intro"
        case syntom = "3drecovery-question-syntom"
        case loading = "3drecovery-question-generate-recovery-loading"
    }

    struct Sprint {
        static let Intro = "sprint-key-intro"
        static let IntroContinue = "sprint-key-intro-continue"
        static let Selection = "sprint-key-sprint-selection"
        static let Schedule = "sprint-key-schedule"
        static let Last = "sprint-key-last-question"
    }

    struct SprintReflection {
        static let Intro = "sprint-post-reflection-key-intro"
        static let Notes01 = "sprint-post-reflection-key-notes-01"
        static let Notes02 = "sprint-post-reflection-key-notes-02"
        static let Notes03 = "sprint-post-reflection-key-notes-03"
        static let Review = "sprint-post-reflection-key-review"
    }
}
