//
//  DecisionTreeModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

// MARK: - TreeType

enum DecisionTreeType {
    case toBeVisionGenerator
    case prepare
}

// MARK: - AnswerType

enum AnswerType: String {
    case singleSelection = "DECISION_TREE_SINGLE_SELECTION"
    case multiSelection = "DECISION_TREE_MULTI_SELECTION"
    case text = "DECISION_TREE_TEXT"
    case userInput = "DECISION_TREE_USER_INPUT"
    case onlyExistingAnswer = "ONLY_EXISTING_ANSWER"
    case noAnswerRequired = "NO_ANSWER_REQUIRED"
}

// MARK: - Question Key

enum QuestionKey: String {
    case intro = "tbv-generator-key-intro"
    case instructions = "tbv-generator-key-instructions"
    case home = "tbv-generator-key-home"
    case work = "tbv-generator-key-work"
    case next = "tbv-generator-key-next"
    case create = "tbv-generator-key-create"
    case picture = "tbv-generator-key-picture"
    case review = "tbv-generator-key-review"
}

// MARK: - Model

struct DecisionTreeModel {
    var questions: [Question]
    var selectedAnswers: [SelectedAnswer]

    struct SelectedAnswer {
        let questionID: Int
        let answer: Answer
    }
}

// MARK: - ModelInterface

extension DecisionTreeModel: DecisionTreeModelInterface {

    mutating func add(_ question: Question) {
        if questions.filter ({ $0.remoteID.value == question.remoteID.value }).isEmpty {
            questions.append(question)
        }
    }

    mutating func add(_ selection: DecisionTreeModel.SelectedAnswer) {
        if selectedAnswers.filter ({ $0.answer.remoteID.value == selection.answer.remoteID.value }).isEmpty {
            selectedAnswers.append(selection)
        }
    }

    mutating func addOrRemove(_ selection: DecisionTreeModel.SelectedAnswer,
                              addCompletion: (() -> Void),
                              removeCompletion: () -> Void) {
        if let index = selectedAnswers.firstIndex(where: { $0.answer.remoteID.value == selection.answer.remoteID.value }) {
            selectedAnswers.remove(at: index)
            removeCompletion()
            return
        }
        selectedAnswers.append(selection)
        addCompletion()
    }

    mutating func remove(_ question: Question) {
        if let index = questions.firstIndex(where: { $0.localID == question.localID }) {
            questions.remove(at: index)
        }
    }

    mutating func removeLastQuestion() {
        if questions.count > 1 {
            questions.removeLast()
        }
    }

    mutating func reset() {
        questions.removeAll()
        selectedAnswers.removeAll()
    }
}
