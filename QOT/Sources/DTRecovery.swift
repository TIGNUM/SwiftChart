//
//  DTRecovery.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Recovery {
	struct QuestionKey {
        static let Intro = "3drecovery-question-intro"
        static let Symptom = "3drecovery-question-syntom"
        static let SymptomGeneral = "3drecovery-question-syntom-general"
        static let GeneratePlan = "3drecovery-question-generate-recovery-loading"
        static let Last = "3drecovery-question-end"
    }

    struct AnswerKey {
        static let Cognitive = "3drecovery-cognitive-item"
        static let Emotional = "3drecovery-emotional-item"
        static let Physical = "3drecovery-physical-item"
    }

    enum FatigueSymptom {
        case cognitive
        case emotional
        case physical
        case general

        var replacement: String? {
            switch self {
            case .cognitive: return R.string.localized.fatigueSymptomCognitive()
            case .emotional: return R.string.localized.fatigueSymptomEmotional()
            case .physical: return R.string.localized.fatigueSymptomPhysical()
            case .general: return nil
            }
        }

        var answerFilter: String {
            switch self {
            case .cognitive: return "3drecovery_relationship_cognitive"
            case .emotional: return "3drecovery_relationship_emotional"
            case .physical: return "3drecovery_relationship_physical"
            case .general: return "3drecovery_relationship_general"
            }
        }

        var fatigueContentItemId: Int {
            switch self {
            case .cognitive: return 104463
            case .emotional: return 104462
            case .physical: return 104464
            case .general: return 104465
            }
        }
    }

    static func getFatigueSymptom(_ selectedAnswers: [DTViewModel.Answer]) -> Recovery.FatigueSymptom {
        let keys = selectedAnswers.flatMap { $0.keys }
        let referenceValue = selectedAnswers.count < 3 ? selectedAnswers.count : 2
        if (keys.filter { $0.contains(Recovery.AnswerKey.Cognitive) }).count == referenceValue {
            return .cognitive
        }
        if (keys.filter { $0.contains(Recovery.AnswerKey.Emotional) }).count == referenceValue {
            return .emotional
        }
        if (keys.filter { $0.contains(Recovery.AnswerKey.Physical) }).count == referenceValue {
            return .physical
        }
        return .general
    }
}
