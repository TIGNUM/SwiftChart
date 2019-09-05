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
    var questions: [RatingQuestionViewModel.Question]?

    // MARK: - Init

    init(questionService: qot_dal.QuestionService, healthService: qot_dal.HealthService) {
        self.questionService = questionService
        self.healthService = healthService
    }

    func getQuestions(_ completion: @escaping([RatingQuestionViewModel.Question]?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var dailyCheckInQuestions = [QDMQuestion]()
        var hasSleepQuality = false
        var hasSleepQuantity = false

        dispatchGroup.enter()
        healthService.hasSleepData(from: Date.beginingOfDay(), to: Date.endOfDay()) { (hasSleepHourData) in
            hasSleepQuantity = hasSleepHourData
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        healthService.healthTrackerDataForToday { (trackerData) in
            hasSleepQuality = trackerData?.userHealthReadinessId != nil
            hasSleepQuantity = trackerData?.userHealthSleepId != nil || hasSleepQuantity
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        questionService.dailyCheckInQuestions { (questions) in
            dailyCheckInQuestions = questions ?? []
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            var keysToFilter = [String]()
            if hasSleepQuality {
                keysToFilter.append("sleep.quality")
            }
            if hasSleepQuantity {
                keysToFilter.append("sleep.quantity.time")
            }

            let finalQuestions = dailyCheckInQuestions.filter({ keysToFilter.contains(obj: $0.key) != true })
                .compactMap { (question) -> RatingQuestionViewModel.Question? in
                    guard let remoteID = question.remoteID else { return nil }
                    let answers = question.answers.compactMap({ (answer) -> RatingQuestionViewModel.Answer in
                        return RatingQuestionViewModel.Answer(remoteID: answer.remoteID,
                                                              title: answer.title,
                                                              subtitle: answer.subtitle)
                    })
                    return RatingQuestionViewModel.Question(remoteID: remoteID,
                                                            title: question.title,
                                                            htmlTitle: question.htmlTitleString,
                                                            subtitle: question.subtitle,
                                                            dailyPrepTitle: question.dailyPrepTitle,
                                                            key: question.key,
                                                            answers: answers,
                                                            range: nil,
                                                            toBeVisionTrackId: question.toBeVisionTrackId,
                                                            SHPIQuestionId: question.SHPIQuestionId,
                                                            groups: question.groups,
                                                            buttonText: question.defaultButtonText,
                                                            selectedAnswerIndex: nil)
            }
            self?.questions = finalQuestions
            completion(finalQuestions)
        }
    }
}
