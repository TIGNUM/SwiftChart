//
//  DTSprintViewModel.swift
//  QOT
//
//  Created by karmic on 08.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct ViewModel {
    let question: Question
    var answers: [Answer]
    let navigationButton: NavigationButton?
    let hasTypingAnimation: Bool
    let previousButtonIsHidden: Bool
    let dismissButtonIsHidden: Bool

    mutating func setSelectedAnswer(_ answer: Answer) {
        if let index = indexOf(answer.remoteId) {
            answers.remove(at: index)
            answers.insert(answer, at: index)
        }
    }

    struct Question {
        let title: String
        let key: String
        let answerType: AnswerType
        let maxSelections: Int = 0
    }

    struct Answer: Equatable {
        let remoteId: Int
        let title: String
        let keys: [String]
        var selected: Bool
        var backgroundColor: UIColor
        let decisions: [Decision]

        static func == (lhs: ViewModel.Answer, rhs: ViewModel.Answer) -> Bool {
            return lhs.remoteId == rhs.remoteId && lhs.title == rhs.title && lhs.keys == rhs.keys
        }

        func targetId(_ type: TargetType) -> Int? {
            return decisions.first(where: { $0.targetType == type })?.targetTypeId
        }

        struct Decision {
            let targetType: TargetType
            let targetTypeId: Int?
        }

        mutating func setSelected(_ selected: Bool) {
            self.selected = selected
        }
    }
}

extension ViewModel {
    func indexOf(_ answerId: Int) -> Int? {
        return answers.firstIndex(where: { $0.remoteId == answerId })
    }
}
