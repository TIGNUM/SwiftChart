//
//  DTSprintReflectionPresenter.swift
//  QOT
//
//  Created by Michael Karbe on 17.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintReflectionPresenter: DTPresenter {

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == SprintReflection.QuestionKey.Intro || questionKey == SprintReflection.QuestionKey.Review
    }

    override func updatedQuestionTitle(_ question: QDMQuestion?, replacement: String?) -> String? {
        if let replacement = replacement {
            return question?.title.replacingOccurrences(of: "${sprintName}", with: replacement)
        }
        return nil
    }
}

// MARK: - DTSprintReflectionInterface
extension DTSprintReflectionPresenter: DTSprintReflectionPresenterInterface {}
