//
//  DecisionTreeModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum CellType: Int, CaseIterable {
    case question
    case answer
}

// MARK: - TreeType
enum DecisionTreeType {
    case toBeVisionGenerator
    case mindsetShifter
    case mindsetShifterTBV
    case mindsetShifterTBVOnboarding
    case mindsetShifterTBVPrepare
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
            return QuestionKey.ToBeVision.Instructions
        case .mindsetShifter:
            return QuestionKey.MindsetShifter.Intro
        case .mindsetShifterTBV:
            return QuestionKey.MindsetShifterTBV.Intro
        case .mindsetShifterTBVOnboarding:
            return QuestionKey.MindsetShifterTBV.IntroOnboarding
        case .mindsetShifterTBVPrepare:
            return QuestionKey.MindsetShifterTBV.IntroPrepare
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
             .mindsetShifterTBVOnboarding,
             .mindsetShifterTBVPrepare:
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

    func barButtonTextColor(_ enabled: Bool) -> UIColor {
        switch (self, enabled) {
        case (.mindsetShifterTBVOnboarding, false):
            return .sand30
        case (_, false):
            return .carbonNew30
        default:
            return .accent
        }
    }

    func barButtonBackgroundColor(_ enabled: Bool) -> UIColor {
        switch (self, enabled) {
        case (.mindsetShifterTBVOnboarding, false):
            return .sand08
        case (_, false):
            return .carbonNew08
        default:
            return .carbonNew
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
            return .accent30
        }
    }

    func buttonSelectedBackgroundColor(_ selected: Bool) -> UIColor {
        switch self {
        case .mindsetShifterTBVOnboarding:
            return .carbon30
        default:
            return selected ? .clear : .accent30
        }
    }

    var buttonDefaultTextColor: UIColor {
        return .accent
    }

    var borderDefaultColor: UIColor {
        return .accent30
    }

    var navigationButtonBackgroundColorActive: UIColor {
        return .carbonNew
    }
}

extension QDMQuestion {
    var hasTypingAnimation: Bool {
        get {
            switch key {
            case QuestionKey.Sprint.Intro,
                 QuestionKey.MindsetShifter.LowSelfTalk: return true
            default: return false
            }
        }
    }
}

// MARK: - Model
struct DecisionTreeModel {
    typealias Filter = String
    var extendedQuestions: [ExtendedQuestion] = []
    var selectedAnswers: [SelectedAnswer] = []

    struct SelectedAnswer: Equatable {
        let questionID: Int
        let answer: QDMAnswer

        static func == (lhs: DecisionTreeModel.SelectedAnswer, rhs: DecisionTreeModel.SelectedAnswer) -> Bool {
            return
                lhs.questionID == rhs.questionID &&
                lhs.answer.remoteID == rhs.answer.remoteID &&
                lhs.answer.title == rhs.answer.title &&
                lhs.answer.subtitle == rhs.answer.subtitle &&
                lhs.answer.sortOrder == rhs.answer.sortOrder
        }
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
            let lastQuestionId = extendedQuestions.last?.question.remoteID
            extendedQuestions.removeLast()
            let lastSelectedAnswers = selectedAnswers.filter { $0.questionID == lastQuestionId }
            lastSelectedAnswers.forEach { (answer) in
                selectedAnswers.remove(object: answer)
            }
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
