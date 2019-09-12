//
//  DTMindsetPresenter.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTMindsetPresenter: DTPresenter {

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == Mindset.QuestionKey.Intro || questionKey == Mindset.QuestionKey.Last
    }

    override func hasTypingAnimation(answerType: AnswerType, answers: [DTViewModel.Answer]) -> Bool {
        return answerType == .text
    }

    override func dismissButtonIsHidden(questionKey: String) -> Bool {
        return questionKey == Mindset.QuestionKey.Last
    }
}
