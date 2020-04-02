//
//  DTRecoveryWorker.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTRecoveryWorker: DTWorker {
    func createRecovery(selectedAnswers: [SelectedAnswer], _ completion: @escaping (QDMRecovery3D?) -> Void) {
        let answers = selectedAnswers.flatMap { $0.answers }
        let fatigueContentItemId = Recovery.getFatigueSymptom(answers).fatigueContentItemId
        let causeAnswer = selectedAnswers
            .filter { $0.question?.key == Recovery.QuestionKey.Symptom
                || $0.question?.key == Recovery.QuestionKey.SymptomGeneral }
            .first?.answers.first
        let causeAnswerId = causeAnswer?.remoteId ?? 0
        let causeContentItemId = causeAnswer?.targetId(.contentItem) ?? 0
        let causeContentId = causeAnswer?.targetId(.content) ?? 0

        ContentService.main.getContentCollectionById(causeContentId) { (content) in
            var model = CreateRecovery3DModel()
            model.fatigueContentItemId = fatigueContentItemId
            model.causeAnwserId = causeAnswerId
            model.causeContentItemId = causeContentItemId
            model.exclusiveContentCollectionIds = content?.exclusiveContentIds ?? []
            model.suggestedSolutionsContentCollectionIds = content?.suggestedContentIds ?? []

            UserService.main.createRecovery3D(data: model) { (recovery, error) in
                if let error = error {
                    log("Error createRecovery: \(error.localizedDescription)", level: .error)
                }
                completion(recovery)
            }
        }
    }
}
