//
//  DTViewModel.swift
//  QOT
//
//  Created by karmic on 08.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct DTViewModel {
    let question: Question
    var answers: [Answer]
    let tbvText: String?
    let hasTypingAnimation: Bool
    let typingAnimationDuration: Double
    let previousButtonIsHidden: Bool
    let dismissButtonIsHidden: Bool
    let showNextQuestionAutomated: Bool

    // -ReadOnly
    var selectedAnswers: [DTViewModel.Answer] {
        return answers.filter { $0.selected }
    }

    struct Question {
        let remoteId: Int
        let title: String
        let key: String
        let answerType: AnswerType
        let duration: Double
        let maxSelections: Int
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
    mutating func setSelectedAnswer(_ answer: Answer) {
        if let index = indexOf(answer.remoteId) {
            answers.remove(at: index)
            answers.insert(answer, at: index)
            if question.answerType == .multiSelection {
                notifyCounterChanged()
            }
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
