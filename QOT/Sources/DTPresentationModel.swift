//
//  DTPresentationModel.swift
//  QOT
//
//  Created by karmic on 08.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct DTPresentationModel {
    let question: QDMQuestion?
    let questionUpdate: String?
    let answerFilter: String?
    let userInputText: String?
    let tbv: QDMToBeVision?
    let selectedIds: [Int]
    let preparations: [QDMUserPreparation]
    let poll: QDMTeamToBeVisionPoll?

    init(question: QDMQuestion?,
         questionUpdate: String?,
         answerFilter: String?,
         userInputText: String?,
         tbv: QDMToBeVision?,
         selectedIds: [Int],
         preparations: [QDMUserPreparation],
         poll: QDMTeamToBeVisionPoll?) {
        self.question = question
        self.questionUpdate = questionUpdate
        self.answerFilter = answerFilter
        self.userInputText = userInputText
        self.tbv = tbv
        self.selectedIds = selectedIds
        self.preparations = preparations
        self.poll = poll
    }

    init(question: QDMQuestion?, poll: QDMTeamToBeVisionPoll?) {
        self.question = question
        self.questionUpdate = nil
        self.answerFilter = nil
        self.userInputText = nil
        self.tbv = nil
        self.selectedIds = []
        self.preparations = []
        self.poll = poll
    }

    var answerType: AnswerType {
        return AnswerType(rawValue: question?.answerType ?? "") ?? .singleSelection
    }

    func getNavigationButton(isHidden: Bool, isDark: Bool) -> NavigationButton? {
        guard let question = question else { return nil }
        if question.defaultButtonText?.isEmpty == true && question.confirmationButtonText?.isEmpty == true {
            return nil
        }
        let title = question.defaultButtonText?.isEmpty == true ? question.confirmationButtonText : question.defaultButtonText
        let navigationButton = NavigationButton.instantiateFromNib()
        navigationButton.configure(title: title ?? "", minSelection: .zero, isDark: isDark)
        if !answerType.isEnabled,
            let maxSelections = question.maxPossibleSelections,
            let defaultTitle = question.defaultButtonText,
            let confirmationTitle = question.confirmationButtonText {
            var minSelections = maxSelections
            if let min = question.minPossibleSelections {
                minSelections = min
            }
            navigationButton.configure(title: defaultTitle,
                                       titleNext: confirmationTitle,
                                       minSelection: minSelections,
                                       isDark: isDark)
            navigationButton.update(count: .zero, maxSelections: maxSelections)
        }
        navigationButton.isHidden = isHidden
        return navigationButton
    }
}
