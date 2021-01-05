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
        return false
    }

    override func hasTypingAnimation(answerType: AnswerType, answers: [DTViewModel.Answer]) -> Bool {
        let typingAnimationState = answerType == .noAnswerRequired
        if typingAnimationState {
            hideNavigationButtonForAnimation()
        }
        return typingAnimationState
    }

    override func updatedQuestionTitle(_ question: QDMQuestion?, replacement: String?) -> String? {
        if let replacement = replacement {
            if question?.key == Sprint.QuestionKey.Schedule {
                return replacement
            }
            return question?.title.replacingOccurrences(of: "${sprintName}", with: replacement)
        }
        return nil
    }

    override func showNextQuestionAutomated(questionKey: String) -> Bool {
        return questionKey == Sprint.QuestionKey.Intro
    }
}

extension DTSprintPresenter: DTSprintPresenterInterface {
    func presentPermissionView(_ permissionType: AskPermission.Kind) {
        guard let viewController = viewController as? DTSprintViewController else { return }
        viewController.presentPermissionView(permissionType)
    }
}
