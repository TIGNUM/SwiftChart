//
//  AnswerKeys.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 21.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - AnswerKey

enum AnswerKey {

    enum ToBeVision: String {
        case uploadImage = "tbv-answer-key-upload-image"
    }

    struct Prepare {
        static let OpenCheckList = "open_preparation_check_list_on_the_go"
        static let OpenCalendarEventSelectionDaily = "prepare-key-calendar-event-selection-daily"
        static let EventTypeSelectionDaily = "open_preparation_event_selection_daily"
        static let EventTypeSelectionCritical = "open_preparation_event_selection_critical"
        static let PeakPlanNew = "prepare_peak_prep_plan_new"
        static let PeakPlanTemplate = "prepare_peak_prep_plan_template"
    }

    enum Solve: String {
        case letsDoIt = "solve-lets-do-it"
        case openVisionPage = "open-vision-page"
        case openResult = "open_result_view"
    }

    enum Recovery: String {
        case cognitive = "3drecovery-cognitive-item"
        case emotional = "3drecovery-emotional-item"
        case physical = "3drecovery-physical-item"
        case general = ""

        var replacement: String {
            switch self {
            case .cognitive: return R.string.localized.fatigueSymptomCognitive()
            case .emotional: return R.string.localized.fatigueSymptomEmotional()
            case .physical: return R.string.localized.fatigueSymptomPhysical()
            case .general: return R.string.localized.fatigueSymptomGeneral()
            }
        }

        var fatigueAnswerId: Int {
            switch self {
            case .cognitive: return 104463
            case .emotional: return 104462
            case .physical: return 104464
            case .general: return 104465
            }
        }

        static func identifyFatigueSympton(_ selectedAnswers: [QDMAnswer]) -> AnswerKey.Recovery {
            var fatigueType = Recovery.general
            let keys = selectedAnswers.flatMap { $0.keys }
            if (keys.filter { $0.contains(AnswerKey.Recovery.cognitive.rawValue) }).count > 1 {
                fatigueType = AnswerKey.Recovery.cognitive
            }
            if (keys.filter { $0.contains(AnswerKey.Recovery.emotional.rawValue) }).count > 1 {
                fatigueType = AnswerKey.Recovery.emotional
            }
            if (keys.filter { $0.contains(AnswerKey.Recovery.physical.rawValue) }).count > 1 {
                fatigueType = AnswerKey.Recovery.physical
            }
            return fatigueType
        }
    }

    enum Sprint: String {
        case startTomorrow = "sprint-answer-key-start-tomorrow"
        case addToQueue = "sprint-answer-key-add-to-queue"
    }

    struct SprintReflection {
        static let Intro = "sprint-post-reflection-key-intro"
        static let Notes01 = "sprint-post-reflection-key-notes-01"
        static let Notes02 = "sprint-post-reflection-key-notes-02"
        static let Notes03 = "sprint-post-reflection-key-notes-03"
        static let DoItLater = "sprint-post-reflection-key-do-it-later"
        static let TrackTBV = "sprint-post-reflection-key-track-my-tbv"
    }
}
