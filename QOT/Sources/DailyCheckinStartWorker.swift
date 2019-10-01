//
//  DailyCheckinStartWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 12.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyCheckinStartWorker {

    // MARK: - Properties
    private let questionService: qot_dal.QuestionService
    private let healthService: qot_dal.HealthService

    // MARK: - Init

    init(questionService: qot_dal.QuestionService, healthService: qot_dal.HealthService) {
        self.questionService = questionService
        self.healthService = healthService
    }

    func getQuestion(_ completion: @escaping(RatingQuestionViewModel.Question?) -> Void) {
        questionService.dailyCheckInQuestions { (questions) in
            let dailyCheckInQuestions = questions ?? []
            guard let introQuestion = dailyCheckInQuestions.filter({ $0.key == dailyCheckInIntroQuestionKey }).first,
                let remoteID = introQuestion.remoteID else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
            }
            let answers = introQuestion.answers.sorted(by: {$0.sortOrder ?? 0 > $1.sortOrder ?? 0})
                .compactMap({ (answer) -> RatingQuestionViewModel.Answer in
                    return RatingQuestionViewModel.Answer(remoteID: answer.remoteID,
                                                          title: answer.title,
                                                          subtitle: answer.subtitle)
                })

            let viewModelQuestion = RatingQuestionViewModel.Question(remoteID: remoteID,
                                                                     title: introQuestion.title,
                                                                     htmlTitle: introQuestion.htmlTitleString,
                                                                     subtitle: introQuestion.subtitle,
                                                                     dailyPrepTitle: introQuestion.dailyPrepTitle,
                                                                     key: introQuestion.key,
                                                                     answers: answers,
                                                                     range: nil,
                                                                     toBeVisionTrackId: introQuestion.toBeVisionTrackId,
                                                                     SHPIQuestionId: introQuestion.SHPIQuestionId,
                                                                     groups: introQuestion.groups,
                                                                     buttonText: introQuestion.defaultButtonText,
                                                                     selectedAnswerIndex: nil)
            DispatchQueue.main.async {
                completion(viewModelQuestion)
            }
        }
    }
}
