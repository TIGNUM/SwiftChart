//
//  DTSolvePresenter.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSolvePresenter: DTPresenter {

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == Solve.QuestionKey.Intro
    }

//    override func hasTypingAnimation(answerType: AnswerType, answers: [DTViewModel.Answer]) -> Bool {
//        let typingAnimationState = answerType == .text
//        if typingAnimationState {
//            hideNavigationButtonForAnimation()
//        }
//        return typingAnimationState
//    }
}
