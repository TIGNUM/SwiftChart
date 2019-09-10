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
    let selectedAnswer: DTViewModel.Answer?
    let answerFilter: String?
    let userInput: String?
    let tbv: QDMToBeVision?
    let trigger: String?

    init(selectedAnswer: DTViewModel.Answer?,
         trigger: String?,
         answerFilter: String?,
         userInput: String?,
         tbv: QDMToBeVision?) {
        self.selectedAnswer = selectedAnswer
        self.answerFilter = answerFilter
        self.userInput = userInput
        self.trigger = trigger
        self.tbv = tbv
    }

    init(selectedAnswer: DTViewModel.Answer?, userInput: String?) {
        self.selectedAnswer = selectedAnswer
        self.userInput = userInput
        self.answerFilter = nil
        self.trigger = nil
        self.tbv = nil
    }

    init (selectedAnswer: DTViewModel.Answer?) {
        self.selectedAnswer = selectedAnswer
        self.answerFilter = nil
        self.userInput = nil
        self.trigger = nil
        self.tbv = nil
    }
}
