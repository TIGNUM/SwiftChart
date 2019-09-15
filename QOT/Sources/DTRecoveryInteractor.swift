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
    private lazy var recoveryWorker: DTRecoveryWorker? = DTRecoveryWorker()

    override func getTitleUpdate(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        if questionKey == Recovery.QuestionKey.Symptom {
            return Recovery.getFatigueSymptom(selectedAnswers).replacement
        }
        return nil
    }

    override func getNextQuestion(selection: DTSelectionModel, questions: [QDMQuestion]) -> QDMQuestion? {
        if let nextQuestionKey = nextQuestionKey {
            let nextQuestion = questions.filter { $0.key == nextQuestionKey }.first
            self.nextQuestionKey = nil
            return nextQuestion
        } else {
            let targetQuestionId = selection.selectedAnswers.first?.targetId(.question)
            return questions.filter { $0.remoteID == targetQuestionId }.first
        }
    }
}

// MARK: - DTRecoveryInteractorInterface
extension DTRecoveryInteractor: DTRecoveryInteractorInterface {
    func getRecovery3D(_ completion: @escaping (QDMRecovery3D?) -> Void) {
        recoveryWorker?.createRecovery(selectedAnswers: selectedAnswers, completion)
    }
}
