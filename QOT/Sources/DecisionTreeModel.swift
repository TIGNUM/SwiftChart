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
    case sprint

    var introKey: String {
        switch self {
        case .toBeVisionGenerator:
            return QuestionKey.ToBeVision.intro.rawValue
        case .mindsetShifter:
            return QuestionKey.MindsetShifter.intro.rawValue
        case .mindsetShifterTBV:
            return QuestionKey.MindsetShifterTBV.intro.rawValue
        case .prepare, .prepareIntensions, .prepareBenefits:
            return QuestionKey.Prepare.intro.rawValue
        case .solve:
            return QuestionKey.Solve.intro.rawValue
        case .recovery:
            return QuestionKey.Recovery.intro.rawValue
        case .sprint:
            return QuestionKey.Sprint.intro.rawValue
        }
    }

    var questionGroup: qot_dal.QuestionGroup {
        switch self {
        case .toBeVisionGenerator:
            return .ToBeVision_3_0
        case .mindsetShifter:
            return .MindsetShifter
        case .mindsetShifterTBV:
            return .MindsetShifterToBeVision
        case .prepare, .prepareIntensions, .prepareBenefits:
            return .Prepare_3_0
        case .solve:
            return .Solve
        case .recovery:
            return .RecoveryPlan
        case .sprint:
            return .Sprint
        }
    }
}

//TODO Move to better place && MORE IMPORTANT -> type: DecisionTreeType as Question property
extension QDMQuestion {
    var type: DecisionTreeType? {
        get {
            if !(groups.filter { $0.id == qot_dal.QuestionGroup.ToBeVision_3_0.rawValue }).isEmpty {
                return .toBeVisionGenerator
            }
            if !(groups.filter { $0.id == qot_dal.QuestionGroup.MindsetShifter.rawValue }).isEmpty {
                return .mindsetShifter
            }
            if !(groups.filter { $0.id == qot_dal.QuestionGroup.MindsetShifterToBeVision.rawValue }).isEmpty {
                return .mindsetShifterTBV
            }
            if !(groups.filter { $0.id == qot_dal.QuestionGroup.Prepare.rawValue }).isEmpty {
                return .prepare
            }
            if !(groups.filter { $0.id == qot_dal.QuestionGroup.Solve.rawValue }).isEmpty {
                return .solve
            }
            if !(groups.filter { $0.id == qot_dal.QuestionGroup.RecoveryPlan.rawValue }).isEmpty {
                return .recovery
            }
            if !(groups.filter { $0.id == qot_dal.QuestionGroup.Sprint.rawValue }).isEmpty {
                return .sprint
            }
            return nil
        }
    }

    var hasTypingAnimation: Bool {
        get {
            switch key {
            case QuestionKey.Sprint.intro.rawValue?:
                return true
            default:
                return false
            }
        }
    }
}

// MARK: - Model

struct DecisionTreeModel {
    typealias Filter = String
    var questions: [QDMQuestion] = []
    var selectedAnswers: [SelectedAnswer] = []

    struct SelectedAnswer {
        let questionID: Int
        let answer: QDMAnswer
    }

    init(question: QDMQuestion) {
        questions.append(question)
    }
}

extension DecisionTreeModel.Filter {
    static let FILTER_RELATIONSHIP = "_relationship_"
    static let FILTER_REACTION = "-reaction-"
}

// MARK: - ModelInterface

extension DecisionTreeModel: DecisionTreeModelInterface {

    mutating func add(_ question: QDMQuestion) {
        if questions.filter ({ $0.remoteID == question.remoteID }).isEmpty {
            questions.append(question)
        }
    }

    mutating func remove(_ question: QDMQuestion) {
        if let index = questions.firstIndex(where: { $0.remoteID == question.remoteID }) {
            questions.remove(at: index)
        }
    }

    mutating func add(_ selection: DecisionTreeModel.SelectedAnswer) {
        if selectedAnswers.filter ({ $0.answer.remoteID == selection.answer.remoteID }).isEmpty {
            selectedAnswers.append(selection)
        }
    }

    mutating func remove(_ selection: DecisionTreeModel.SelectedAnswer) {
        if let index = selectedAnswers.firstIndex(where: { $0.answer.remoteID == selection.answer.remoteID }) {
            selectedAnswers.remove(at: index)
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
