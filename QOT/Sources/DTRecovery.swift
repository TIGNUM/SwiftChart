//
//  DTRecovery.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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
            case .cognitive: return AppTextService.get(AppTextKey.coach_tools_interactive_tool_3drecovery_questionnaire_section_body_label_cognitive)
            case .emotional: return AppTextService.get(AppTextKey.coach_tools_interactive_tool_3drecovery_questionnaire_section_body_label_emotional)
            case .physical: return AppTextService.get(AppTextKey.coach_tools_interactive_tool_3drecovery_questionnaire_section_body_label_physical)
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
        let keys = selectedAnswers.flatMap { $0.keys.filter { $0.contains("-item") } }

        if keys.count == 1 {
            return symptomForKey(keys.first ?? "")
        }

        if keys.count == 2 {
            if keys.first == keys.last {
                return symptomForKey(keys.first ?? "")
            }
            return .general
        }

        let cognitiveCount = keys.filter { $0.contains(Recovery.AnswerKey.Cognitive) }.count
        let emotionalCount = keys.filter { $0.contains(Recovery.AnswerKey.Emotional) }.count
        let physicalCount = keys.filter { $0.contains(Recovery.AnswerKey.Physical) }.count

        if cognitiveCount == emotionalCount && cognitiveCount == physicalCount {
            return .general
        }

        if cognitiveCount == 2 || cognitiveCount == 3 {
            return .cognitive
        }

        if emotionalCount == 2 || emotionalCount == 3 {
            return .emotional
        }

        if physicalCount == 2 || physicalCount == 3 {
            return .physical
        }

        return .general
    }

    private static func symptomForKey(_ key: String) -> Recovery.FatigueSymptom {
        switch key {
        case Recovery.AnswerKey.Cognitive:
            return .cognitive
        case Recovery.AnswerKey.Emotional:
            return .emotional
        case Recovery.AnswerKey.Physical:
            return .physical
        default:
            return .general
        }
    }
 }
