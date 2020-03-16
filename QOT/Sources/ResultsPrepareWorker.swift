//
//  ResultsPrepareWorker.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPrepareWorker {

    // MARK: - Init
    init() { /**/ }

}

// MARK: - DTViewModel
extension ResultsPrepareWorker {
    func getDTViewModel(_ key: Prepare.Key,
                        preparation: QDMUserPreparation?,
                        _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void) {
        let selectedIds: [Int] = getSelectedIds(key: key, preparation: preparation)
        QuestionService.main.question(with: key.questionID, in: .Prepare_3_0) { (qdmQuestion) in
            guard let qdmQuestion = qdmQuestion else { return }
            let question = DTViewModel.Question(qdmQuestion: qdmQuestion)
            let filteredAnswers = qdmQuestion.answers.filter { $0.keys.contains(preparation?.answerFilter ?? "") }
            let answers = filteredAnswers.compactMap { DTViewModel.Answer(qdmAnswer: $0, selectedIds: selectedIds) }
            completion(DTViewModel(question: question,
                                   answers: answers,
                                   events: [],
                                   tbvText: nil,
                                   userInputText: preparation?.benefits,
                                   hasTypingAnimation: false,
                                   typingAnimationDuration: 0,
                                   previousButtonIsHidden: true,
                                   dismissButtonIsHidden: false,
                                   showNextQuestionAutomated: false),
                       qdmQuestion)
        }
    }

    func getSelectedIds(key: Prepare.Key, preparation: QDMUserPreparation?) -> [Int] {
        switch key {
        case .feel: return preparation?.feelAnswerIds ?? []
        case .know: return preparation?.knowAnswerIds ?? []
        case .perceived: return preparation?.preceiveAnswerIds ?? []
        default: return []
        }
    }
}
