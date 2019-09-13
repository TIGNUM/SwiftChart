//
//  DTSelectionModel.swift
//  QOT
//
//  Created by karmic on 08.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct DTSelectionModel {
    let selectedAnswers: [DTViewModel.Answer]
    let question: DTViewModel.Question?
    let answerFilter: String?
    let userInput: String?
    let trigger: String?

    init(selectedAnswers: [DTViewModel.Answer],
         question: DTViewModel.Question?,
         trigger: String?,
         answerFilter: String?,
         userInput: String?) {
        self.selectedAnswers = selectedAnswers
        self.answerFilter = answerFilter
        self.userInput = userInput
        self.question = question
        self.trigger = trigger
    }

    init(selectedAnswers: [DTViewModel.Answer], question: DTViewModel.Question?, userInput: String?) {
        self.selectedAnswers = selectedAnswers
        self.userInput = userInput
        self.question = question
        self.answerFilter = nil
        self.trigger = nil
    }

    init(selectedAnswers: [DTViewModel.Answer], question: DTViewModel.Question?) {
        self.selectedAnswers = selectedAnswers
        self.question = question
        self.answerFilter = nil
        self.userInput = nil
        self.trigger = nil
    }
}
