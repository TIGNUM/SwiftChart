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

    enum Prepare: String {
        case intro = "prepare-key-intro"
        case calendarEventSelectionDaily = "prepare-key-calendar-event-selection-daily"
        case calendarEventSelectionCritical = "prepare-key-calendar-event-selection-critical"
        case eventTypeSelectionDaily = "prepare-event-type-selection-daily"
        case eventTypeSelectionCritical = "prepare-event-type-selection-critical"
        case showTBV = "prepare_peak_prep_review_tbv"
        case benefitsInput = "prepare_peak_prep_benefits_input"
        case buildCritical = "prepare_peak_prep_build_plan"
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
}
