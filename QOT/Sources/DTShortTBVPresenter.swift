//
//  DTShortTBVPresenter.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTShortTBVPresenter: DTPresenter {

    var shouldHideDismissButton: Bool = false

    override func dismissButtonIsHidden(questionKey: String) -> Bool {
        if shouldHideDismissButton {
            return true
        }
        return super.dismissButtonIsHidden(questionKey: questionKey)
    }

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == ShortTBV.QuestionKey.IntroMindSet
    }

    override func hasTypingAnimation(answerType: AnswerType, answers: [DTViewModel.Answer]) -> Bool {
        let typingAnimationState = answerType == .text
        if typingAnimationState {
            hideNavigationButtonForAnimation()
        }
        return typingAnimationState
    }

    override func showNextQuestionAutomated(questionKey: String) -> Bool {
        switch questionKey {
        case ShortTBV.QuestionKey.IntroOnboarding,
             ShortTBV.QuestionKey.IntroPrepare:
            return true
        default:
            return false
        }
    }
}
