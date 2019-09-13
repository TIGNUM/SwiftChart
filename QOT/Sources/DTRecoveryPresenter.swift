//
//  DTRecoveryPresenter.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTRecoveryPresenter: DTPresenter {

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == Recovery.QuestionKey.Intro || questionKey == Recovery.QuestionKey.Last
    }

    override func dismissButtonIsHidden(questionKey: String) -> Bool {
        return questionKey == Recovery.QuestionKey.Last
    }

    override func updatedQuestionTitle(_ question: QDMQuestion?, replacement: String?) -> String? {
        if question?.key == Recovery.QuestionKey.Symptom, let replacement = replacement {
            return question?.title.replacingOccurrences(of: "%@", with: replacement)
        }
        return nil
    }
}

// MARK: - DTRecoveryInterface
extension DTRecoveryPresenter: DTRecoveryPresenterInterface {}
