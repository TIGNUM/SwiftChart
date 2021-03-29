//
//  GuidedStoryWorker.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class GuidedStoryWorker {
    var questions = [QDMQuestion]()
    var currentQuestionKey = GuidedStory.Survey.QuestionKey.intro.rawValue
    var selectedAnswers = [String: QDMAnswer]()

    func question(for key: String) -> QDMQuestion? {
        return questions.first(where: { $0.key == key })
    }

    func answers(for key: String) -> [QDMAnswer] {
        return question(for: key)?.answers.sorted(by: { $0.sortOrder ?? .zero > $1.sortOrder ?? .zero }) ?? []
    }

    func answer(at index: Int) -> QDMAnswer? {
        return answers(for: currentQuestionKey).at(index: index)
    }

    func getQuestions(_ completion: @escaping () -> Void) {
        QuestionService.main.questionsWithQuestionGroup(.Onboarding, ascending: true) { (questions) in
            self.questions = questions ?? []
            completion()
        }
    }

    func didSelectAnswer(at index: Int) {
        selectedAnswers[currentQuestionKey] = answer(at: index)
        log("selectedAnswers: \(selectedAnswers)", level: .debug)
    }
}
