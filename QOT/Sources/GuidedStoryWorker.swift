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
    var selectedAnswers = [[QDMQuestion: QDMAnswer]]()

    func question(for key: String) -> QDMQuestion? {
        return questions.first(where: { $0.key == key })
    }

    func getQuestions(_ completion: @escaping () -> Void) {
        QuestionService.main.questionsWithQuestionGroup(.Onboarding, ascending: true) { (questions) in
            self.questions = questions ?? []
            completion()
        }
    }
}
