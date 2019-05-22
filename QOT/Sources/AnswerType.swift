//
//  AnswerType.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 21.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

// MARK: - AnswerType

enum AnswerType: String {
    case yesOrNo = "YES_OR_NO"
    case singleSelection = "DECISION_TREE_SINGLE_SELECTION"
    case multiSelection = "DECISION_TREE_MULTI_SELECTION"
    case text = "DECISION_TREE_TEXT"
    case userInput = "DECISION_TREE_USER_INPUT"
    case onlyExistingAnswer = "ONLY_EXISTING_ANSWER"
    case noAnswerRequired = "NO_ANSWER_REQUIRED"
    case uploadImage = "UPLOAD_IMAGE"
    case lastQuestion = "LAST_QUESTION"
    case openCalendarEvents = "OPEN_CALENDAR_EVENTS"
}
