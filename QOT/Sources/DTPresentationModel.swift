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
    let tbv: QDMToBeVision?
    let events: [QDMUserCalendarEvent]
    let preparations: [QDMUserPreparation]

    init(question: QDMQuestion?,
         questionUpdate: String?,
         answerFilter: String?,
         tbv: QDMToBeVision?,
         events: [QDMUserCalendarEvent],
         preparations: [QDMUserPreparation]) {
        self.question = question
        self.questionUpdate = questionUpdate
        self.answerFilter = answerFilter
        self.tbv = tbv
        self.events = events
        self.preparations = preparations
    }

    init(question: QDMQuestion?) {
        self.question = question
        self.questionUpdate = nil
        self.answerFilter = nil
        self.tbv = nil
        self.events = []
        self.preparations = []
    }

    func getNavigationButton(isHidden: Bool, isDark: Bool) -> NavigationButton? {
        guard let question = question else { return nil }
        if question.defaultButtonText?.isEmpty == true && question.confirmationButtonText?.isEmpty == true {
            return nil
        }
        let enabled = question.answerType != AnswerType.multiSelection.rawValue
        let title = question.defaultButtonText?.isEmpty == true ? question.confirmationButtonText : question.defaultButtonText
        let navigationButton = NavigationButton.instantiateFromNib()
        navigationButton.configure(title: title ?? "", minSelection: 0, isDark: isDark)
        if !enabled,
            let maxSelections = question.maxPossibleSelections,
            let defaultTitle = question.defaultButtonText,
            let confirmationTitle = question.confirmationButtonText {
            var minSelections = maxSelections
            if let min = question.minPossibleSelections {
                minSelections = min
            }
            navigationButton.configure(title: defaultTitle, titleNext: confirmationTitle, minSelection: minSelections, isDark: isDark)
            navigationButton.update(count: 0, maxSelections: maxSelections)
        }
        navigationButton.isHidden = isHidden
        return navigationButton
    }
}
