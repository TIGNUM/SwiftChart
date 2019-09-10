//
//  DTSprintPresenter.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintPresenter: DTPresenter {

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == Sprint.QuestionKey.Intro || questionKey == Sprint.QuestionKey.Last
    }

    override func dismissButtonIsHidden(questionKey: String) -> Bool {
        return questionKey == Sprint.QuestionKey.Last
    }

    override func hasTypingAnimation(questionAnswerType: AnswerType, answers: [DTViewModel.Answer]) -> Bool {
        return questionAnswerType == .noAnswerRequired && !answers.filter { $0.title.isEmpty }.isEmpty //TODO - make this work with new data model for new CMS
    }

    override func updatedQuestionTitle(_ question: QDMQuestion?, replacement: String?) -> String? {
        if let replacement = replacement {
            return question?.title.replacingOccurrences(of: "${sprintName}", with: replacement)
        }
        return nil
    }

    override func answerBackgroundColor(answer: QDMAnswer) -> UIColor {
        return answer.keys.contains(Sprint.AnswerKey.AddToQueue) ? .carbonNew : .clear
    }
}
