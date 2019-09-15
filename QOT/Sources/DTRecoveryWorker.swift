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
            .filter { $0.question?.key == Recovery.QuestionKey.Symptom }.first?.answers.first
        let causeAnswerId = causeAnswer?.remoteId ?? 0
        let causeContentItemId = causeAnswer?.targetId(.contentItem) ?? 0
        let causeContentId = causeAnswer?.targetId(.content) ?? 0

        ContentService.main.getContentCollectionById(causeContentId) { (content) in
            UserService.main.createRecovery3D(fatigueContentItemId: fatigueContentItemId,
                                              causeAnwserId: causeAnswerId,
                                              causeContentItemId: causeContentItemId,
                                              exclusiveContentCollectionIds: content?.exclusiveContentIds ?? [],
                                              suggestedSolutionsContentCollectionIds: content?.suggestedContentIds ?? []) { (recovery, error) in
                                                if let error = error {
                                                    log("Error createRecovery: \(error.localizedDescription)", level: .error)
                                                }
                                                completion(recovery)
            }
        }
    }
}
