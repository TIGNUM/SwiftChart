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
            guard let selectedIndex = question.selectedAnswerIndex,
                let answerCount = question.answers?.count, answerCount > 1 else { continue }
            // we are converting selected Index because we converted selected index in DailyCheckinStartWorker.
            question.selectedAnswerIndex = answerCount - selectedIndex - 1 // - 1, bcause it is index
            var checkInAnswer = QDMDailyCheckInAnswer()
            checkInAnswer.questionId = question.remoteID
            checkInAnswer.SHPIQuestionId = question.SHPIQuestionId
            checkInAnswer.ToBeVisionTrackId = question.toBeVisionTrackId
            checkInAnswer.userAnswer = question.selectedAnswer()?.title
            checkInAnswer.ToBeVisionTrackId = question.toBeVisionTrackId
            checkInAnswer.questionGroupId = question.groups?.first?.id
            checkInAnswer.answerId = question.selectedAnswer()?.remoteID
            if question.key == "daily.checkin.peak.performances" {
                checkInAnswer.PeakPerformanceCount = (question.selectedAnswerIndex ?? 0) + 1 // it's count
            }
            answers.append(checkInAnswer)
        }
        questionService.saveDailyCheckInAnswers(answers) { (error) in
            if let apiError = error {
                qot_dal.log("Save answer error: \(apiError)", level: .error)
            }
            completion()
        }
    }
}
