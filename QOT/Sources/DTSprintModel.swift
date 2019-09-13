//
//  DTSprintModel.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

extension DTSprintModel.QuestionKey {
    static let Intro = "sprint-key-intro"
    static let IntroContinue = "sprint-key-intro-continue"
    static let Selection = "sprint-key-sprint-selection"
    static let Schedule = "sprint-key-schedule"
    static let Last = "sprint-key-last-question"
}

extension DTSprintModel.AnswerKey {
    static let SelectionAnswer = "sprint-answer-key-selection"
    static let StartTomorrow = "sprint-answer-key-start-tomorrow"
    static let AddToQueue = "sprint-answer-key-add-to-queue"
}

struct DTSprintModel {
    typealias QuestionKey = String
    typealias AnswerKey = String
}
