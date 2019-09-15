//
//  DTTBVPresenter.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTTBVPresenter: DTPresenter {

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == TBV.QuestionKey.Instructions
    }

    override func hasTypingAnimation(answerType: AnswerType, answers: [DTViewModel.Answer]) -> Bool {
        let typingAnimationState = answerType == .noAnswerRequired || answerType == .text
        if typingAnimationState {
            hideNavigationButtonForAnimation()
        }
        return typingAnimationState  
    }

    override func dismissButtonIsHidden(questionKey: String) -> Bool {
        return questionKey == TBV.QuestionKey.Review
    }
}

// MARK: - DTTBVInterface
extension DTTBVPresenter: DTTBVPresenterInterface {}
