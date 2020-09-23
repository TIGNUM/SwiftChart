//
//  DTViewModel.swift
//  QOT
//
//  Created by karmic on 08.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class DTViewModel {
    let question: Question
    var answers: [Answer]
    let tbvText: String?
    let userInputText: String?
    let hasTypingAnimation: Bool
    let typingAnimationDuration: Double
    let previousButtonIsHidden: Bool
    let dismissButtonIsHidden: Bool
    let showNextQuestionAutomated: Bool

    init(question: DTViewModel.Question,
                  answers: [DTViewModel.Answer],
                  tbvText: String?,
                  userInputText: String?,
                  hasTypingAnimation: Bool,
                  typingAnimationDuration: Double,
                  previousButtonIsHidden: Bool,
                  dismissButtonIsHidden: Bool,
                  showNextQuestionAutomated: Bool) {
        self.question = question
        self.answers = answers
        self.tbvText = tbvText
        self.userInputText = userInputText
        self.hasTypingAnimation = hasTypingAnimation
        self.typingAnimationDuration = typingAnimationDuration
        self.previousButtonIsHidden = previousButtonIsHidden
        self.dismissButtonIsHidden = dismissButtonIsHidden
        self.showNextQuestionAutomated = showNextQuestionAutomated
    }

    // -ReadOnly
    var selectedAnswers: [DTViewModel.Answer] {
        return answers.filter { $0.selected }
    }

    struct Question {
        var remoteId: Int
        var title: String
        var htmlTitleString: String?
        var key: String
        var answerType: AnswerType
        var duration: Double
        var maxSelections: Int

        init(remoteId: Int,
             title: String,
             htmlTitleString: String?,
             key: String,
             answerType: AnswerType,
             duration: Double,
             maxSelections: Int) {
            self.remoteId = remoteId
            self.title = title
            self.htmlTitleString = htmlTitleString
            self.key = key
            self.answerType = answerType
            self.duration = duration
            self.maxSelections = maxSelections
        }

        init(qdmQuestion: QDMQuestion) {
            self.remoteId = qdmQuestion.remoteID ?? 0
            self.title = qdmQuestion.title
            self.htmlTitleString = nil
            self.key = qdmQuestion.key ?? ""
            self.answerType = AnswerType(rawValue: qdmQuestion.answerType ?? "") ?? .multiSelection
            self.duration = qdmQuestion.layout?.animation?.duration ?? 0
            self.maxSelections = qdmQuestion.maxPossibleSelections ?? 0
        }
    }

    struct Answer: Equatable {
        let remoteId: Int
        let title: String
        let keys: [String]
        var selected: Bool = false
        var backgroundColor: UIColor
        let decisions: [Decision]

        init(remoteId: Int,
             title: String,
             keys: [String],
             selected: Bool,
             backgroundColor: UIColor,
             decisions: [Decision]) {
            self.remoteId = remoteId
            self.title = title
            self.keys = keys
            self.selected = selected
            self.backgroundColor = backgroundColor
            self.decisions = decisions
        }

        init(answer: DTViewModel.Answer, newTargetId: Int) {
            self.remoteId = answer.remoteId
            self.title = answer.title
            self.keys = answer.keys
            self.selected = true
            self.backgroundColor = answer.backgroundColor
            self.decisions = [Decision(answer, newTargetId)]
        }

        init(qdmAnswer: QDMAnswer, selectedIds: [Int], decisions: [Decision]) {
            self.remoteId = qdmAnswer.remoteID ?? 0
            self.title = qdmAnswer.subtitle ?? ""
            self.keys = qdmAnswer.keys
            self.selected = selectedIds.contains(obj: qdmAnswer.remoteID ?? 0)
            self.backgroundColor = .clear
            self.decisions = decisions
        }

        static func == (lhs: DTViewModel.Answer, rhs: DTViewModel.Answer) -> Bool {
            return lhs.remoteId == rhs.remoteId && lhs.title == rhs.title && lhs.keys == rhs.keys
        }

        func targetId(_ type: TargetType) -> Int? {
            return decisions.first(where: { $0.targetType == type })?.targetTypeId
        }

        struct Decision {
            let targetType: TargetType
            let targetTypeId: Int?
            let questionGroupId: Int?
            let targetGroupId: Int?
            let targetGroupName: String?

            init(targetType: TargetType,
                 targetTypeId: Int?,
                 questionGroupId: Int?,
                 targetGroupId: Int?,
                 targetGroupName: String?) {
                self.targetType = targetType
                self.targetTypeId = targetTypeId
                self.questionGroupId = questionGroupId
                self.targetGroupId = targetGroupId
                self.targetGroupName = targetGroupName
            }

            init(_ answer: DTViewModel.Answer, _ newTargetId: Int) {
                self.targetType = .question
                self.targetTypeId = newTargetId
                self.questionGroupId = answer.decisions.first?.questionGroupId
                self.targetGroupId = answer.decisions.first?.targetGroupId
                self.targetGroupName = answer.decisions.first?.targetGroupName
            }
        }

        mutating func setSelected(_ selected: Bool) {
            self.selected = selected
        }
    }
}

private extension DTViewModel {
    func indexOf(_ answerId: Int) -> Int? {
        return answers.firstIndex(where: { $0.remoteId == answerId })
    }
}

extension DTViewModel {
    func setSelectedAnswer(_ answer: Answer) {
        if let index = indexOf(answer.remoteId) {
            answers.remove(at: index)
            answers.insert(answer, at: index)
            if question.answerType == .multiSelection ||
                question.answerType == .singleSelection ||
                question.answerType == .poll {
                    notifyCounterChanged()
            }
        }
    }

    func resetSelectedAnswers() {
        selectedAnswers.forEach { (answer) in
            var answerToReset = answer
            answerToReset.selected = false
            setSelectedAnswer(answerToReset)
        }
    }
}

private extension DTViewModel {
    func notifyCounterChanged() {
        let selectionCounter = UserInfo.multiSelectionCounter.pair(for: self.selectedAnswers.count)
        let selectedAnswers = UserInfo.selectedAnswers.pair(for: self.selectedAnswers)
        NotificationCenter.default.post(name: .didUpdateSelectionCounter,
                                        object: nil,
                                        userInfo: [selectionCounter.key: selectionCounter.value,
                                                   selectedAnswers.key: selectedAnswers.value])
    }
}
