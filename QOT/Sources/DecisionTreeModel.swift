//
//  DecisionTreeModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - TreeType

enum DecisionTreeType {
    case toBeVisionGenerator
    case mindsetShifter
    case mindsetShifterTBV
    case prepare
    case prepareIntensions([DecisionTreeModel.SelectedAnswer], String?, Prepare.Key, PrepareResultsDelegatge?)
    case prepareBenefits(benefits: String?, questionID: Int, PrepareResultsDelegatge?)
    case solve
    case recovery
}

// MARK: - Model

struct DecisionTreeModel {
    typealias Filter = String
    var questions: [Question]
    var selectedAnswers: [SelectedAnswer]

    struct SelectedAnswer {
        let questionID: Int
        let answer: Answer
    }
}

extension DecisionTreeModel.Filter {
    static let FILTER_RELATIONSHIP = "_relationship_"
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
                              addCompletion: () -> Void,
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
