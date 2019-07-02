//
//  AnswerKeys.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 21.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

// MARK: - AnswerKey

enum AnswerKey {

    enum ToBeVision: String {
        case uploadImage = "tbv-answer-key-upload-image"
    }

    enum Prepare: String {
        case openCheckList = "open_preparation_check_list_on_the_go"
        case openCalendarEventSelectionDaily = "prepare-key-calendar-event-selection-daily"
        case eventTypeSelectionDaily = "open_preparation_event_selection_daily"
        case eventTypeSelectionCritical = "open_preparation_event_selection_critical"
    }

    enum Solve: String {
        case letsDoIt = "solve-lets-do-it"
        case openVisionPage = "open-vision-page"
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

        static func identifyFatigueSympton(_ selectedAnswers: [Answer]) -> AnswerKey.Recovery {
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
}
