//
//  DailyCheckinQuestionsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyCheckinQuestionsWorker {

    // MARK: - Properties

    private let questionService: qot_dal.QuestionService
    let questions: [RatingQuestionViewModel.Question]

    // MARK: - Init

    init(questionService: qot_dal.QuestionService, questions: [RatingQuestionViewModel.Question]) {
        self.questionService = questionService
        self.questions = questions
    }

    func saveAnswers(_ completion: @escaping() -> Void) {
        var answers: [QDMDailyCheckInAnswer] = []
        for question in questions {
            var checkInAnswer = QDMDailyCheckInAnswer()
            checkInAnswer.questionId = question.remoteID
            checkInAnswer.questionGroupId = question.remoteID
            checkInAnswer.SHPIQuestionId = question.SHPIQuestionId
            checkInAnswer.ToBeVisionTrackId = question.toBeVisionTrackId
            checkInAnswer.questionGroupId = question.groups?.first?.id
            checkInAnswer.answerId = question.selectedAnswer()?.remoteID
            if question.key == "daily.checkin.peak.performances" {
                checkInAnswer.PeakPerformanceCount = (question.selectedAnswerIndex ?? 0) + 1 // it's count
            }
            answers.append(checkInAnswer)
        }
        questionService.saveDailyCheckInAnswers(answers) { (apiError) in
            if apiError != nil {
                qot_dal.log("Save answer error: \(apiError)", level: .error)
            }
            completion()
        }
    }
}
