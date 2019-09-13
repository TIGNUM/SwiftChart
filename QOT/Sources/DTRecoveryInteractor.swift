//
//  DTRecoveryInteractor.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTRecoveryInteractor: DTInteractor {

    var nextQuestionKey: String? = nil

    override func getTitleUpdate(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        if questionKey == Recovery.QuestionKey.Symptom {
            return Recovery.getFatigueSymptom(selectedAnswers).replacement
        }
        return nil
    }

    override func getNextQuestion(selectedAnswer: DTViewModel.Answer?, questions: [QDMQuestion]) -> QDMQuestion? {
        if let nextQuestionKey = nextQuestionKey {
            let nextQuestion = questions.filter { $0.key == nextQuestionKey }.first
            self.nextQuestionKey = nil
            return nextQuestion
        } else {
            let targetQuestionId = selectedAnswer?.targetId(.question)
            return questions.filter { $0.remoteID == targetQuestionId }.first
        }
    }
}

// MARK: - Private
private extension DTRecoveryInteractor {}

// MARK: - DTRecoveryInteractorInterface
extension DTRecoveryInteractor: DTRecoveryInteractorInterface {}
