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
    case mindsetShifterTBVOnboarding
    case prepare
    case prepareIntentions([DecisionTreeModel.SelectedAnswer], String?, Prepare.Key, PrepareResultsDelegatge?)
    case prepareBenefits(benefits: String?, questionID: Int, PrepareResultsDelegatge?)
    case solve
    case recovery
    case sprint
    case sprintReflection(sprint: QDMSprint)

    var introKey: String {
        switch self {
        case .toBeVisionGenerator:
            return QuestionKey.ToBeVision.Intro
        case .mindsetShifter:
            return QuestionKey.MindsetShifter.Intro
        case .mindsetShifterTBV,
             .mindsetShifterTBVOnboarding:
            return QuestionKey.MindsetShifterTBV.Intro
        case .prepare:
            return QuestionKey.Prepare.Intro
        case .prepareIntentions(_, _, let key, _):
            return key.tag
        case .prepareBenefits:
            return ""
        case .solve:
            return QuestionKey.Solve.Intro
        case .recovery:
            return QuestionKey.Recovery.intro.rawValue
        case .sprint:
            return QuestionKey.Sprint.Intro
        case .sprintReflection:
            return QuestionKey.SprintReflection.Intro
        }
    }

    var questionGroup: qot_dal.QuestionGroup {
        switch self {
        case .toBeVisionGenerator:
            return .ToBeVision_3_0
        case .mindsetShifter:
            return .MindsetShifter
        case .mindsetShifterTBV,
             .mindsetShifterTBVOnboarding:
            return .MindsetShifterToBeVision
        case .prepare,
             .prepareIntentions,
             .prepareBenefits:
            return .Prepare_3_0
        case .solve:
            return .Solve
        case .recovery:
            return .RecoveryPlan
        case .sprint:
            return .Sprint
        case .sprintReflection:
            return .SprintPostReflection
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .mindsetShifterTBVOnboarding:
            return .carbon
        default:
            return .sand
        }
    }

    var textColor: UIColor {
        switch self {
        case .mindsetShifterTBVOnboarding:
            return .sand
        default:
            return .carbon
        }
    }

    var dotsColor: UIColor {
        switch self {
        case .mindsetShifterTBVOnboarding:
            return .sand
        default:
            return .carbonDark
        }
    }

    var navigationButtonTextColor: UIColor {
        switch self {
        case .mindsetShifterTBVOnboarding:
            return .sand30
        default:
            return .carbon30
        }
    }

    var navigationButtonBackgroundColor: UIColor {
        switch self {
        case .mindsetShifterTBVOnboarding:
            return .sand08
        default:
            return .carbonNew08
        }
    }

    func selectedBackgroundColor(_ selected: Bool) -> UIColor {
        switch self {
        case .mindsetShifterTBVOnboarding:
            return .carbon30
        default:
            return selected ? .sand : .accent30
        }
    }

    var buttonDefaultBackgroundColor: UIColor {
        switch self {
        case .mindsetShifterTBVOnboarding:
            return .carbon05
        default:
            return .carbon05
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
            case QuestionKey.Sprint.Intro,
                 QuestionKey.ToBeVision.Create,
                 QuestionKey.MindsetShifter.LowSelfTalk:
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
    var extendedQuestions: [ExtendedQuestion] = []
    var selectedAnswers: [SelectedAnswer] = []

    struct SelectedAnswer {
        let questionID: Int
        let answer: QDMAnswer
    }

    struct ExtendedQuestion {
        var userInput: String?
        let question: QDMQuestion
    }

    init(question: QDMQuestion) {
        extendedQuestions.append(ExtendedQuestion(userInput: nil, question: question))
    }
}

extension DecisionTreeModel.Filter {
    static let Relationship = "_relationship_"
    static let Reaction = "-reaction-"
    static let Trigger = "-trigger-"
    static let LowPerfomance = "-lowperformance-"
}

// MARK: - ModelInterface
extension DecisionTreeModel: DecisionTreeModelInterface {
    mutating func add(_ question: QDMQuestion) {
        if extendedQuestions.filter ({ $0.question.remoteID == question.remoteID }).isEmpty {
            extendedQuestions.append(ExtendedQuestion(userInput: nil, question: question))
        }
    }

    mutating func update(_ question: QDMQuestion?, _ userInput: String?) {
        if
            let question = question,
            let index = indexOf(question.remoteID) {
                extendedQuestions.remove(at: index)
                extendedQuestions.insert(ExtendedQuestion(userInput: userInput, question: question), at: index)
        }
    }

    mutating func remove(_ extendedQuestion: ExtendedQuestion) {
        if let index = indexOf(extendedQuestion.question.remoteID) {
            extendedQuestions.remove(at: index)
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
        if !extendedQuestions.isEmpty {
            extendedQuestions.removeLast()
        }
    }

    mutating func reset() {
        extendedQuestions.removeAll()
        selectedAnswers.removeAll()
    }
}

private extension DecisionTreeModel {
    func indexOf(_ questionId: Int?) -> Int? {
        return extendedQuestions.firstIndex(where: { $0.question.remoteID == questionId })
    }
}
