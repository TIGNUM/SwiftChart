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
    var questions: [RatingQuestionViewModel.Question]?

    // MARK: - Init

    init(questionService: qot_dal.QuestionService) {
        self.questionService = questionService
    }

    func getQuestions(_ completion: @escaping([RatingQuestionViewModel.Question]?) -> Void) {
        questionService.dailyCheckInQuestions {[weak self] (questions) in
            let finalQuestions = questions?.compactMap { (track) -> RatingQuestionViewModel.Question? in
                guard let remoteID = track.remoteID else { return nil }
                let answers = track.answers.compactMap({ (answer) -> RatingQuestionViewModel.Answer in
                    return RatingQuestionViewModel.Answer(remoteID: answer.remoteID,
                                                              title: answer.title,
                                                              subtitle: answer.subtitle)
                })
                return RatingQuestionViewModel.Question(remoteID: remoteID,
                                                            title: track.title,
                                                            htmlTitle: track.htmlTitleString,
                                                            subtitle: track.subtitle,
                                                            dailyPrepTitle: track.dailyPrepTitle,
                                                            key: track.key,
                                                            answers: answers,
                                                            range: nil,
                                                            toBeVisionTrackId: track.toBeVisionTrackId,
                                                            SHPIQuestionId: track.SHPIQuestionId,
                                                            groups: track.groups,
                                                            buttonText: track.defaultButtonText,
                                                            selectedAnswerIndex: nil)
            }
            self?.questions = finalQuestions
            completion(finalQuestions)
        }
    }
}
