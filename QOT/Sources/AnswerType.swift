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
    case accept = "ACCEPT"
    case yesOrNo = "YES_OR_NO"
    case singleSelection = "DECISION_TREE_SINGLE_SELECTION"
    case multiSelection = "DECISION_TREE_MULTI_SELECTION"
    case text = "DECISION_TREE_TEXT"
    case userInput = "DECISION_TREE_USER_INPUT"
    case onlyExistingAnswer = "ONLY_EXISTING_ANSWER"
    case noAnswerRequired = "NO_ANSWER_REQUIRED"
    case uploadImage = "UPLOAD_IMAGE"
    case lastQuestion = "LAST_QUESTION"
    case poll = "DECISION_TREE_POLL"

    var isEnabled: Bool {
        switch self {
        case .accept: return true
        case .yesOrNo: return true
        case .singleSelection: return true
        case .multiSelection: return false
        case .text: return true
        case .userInput: return true
        case .onlyExistingAnswer: return true
        case .noAnswerRequired: return true
        case .uploadImage: return true
        case .lastQuestion: return true
        case .poll: return false
        }
    }
}
