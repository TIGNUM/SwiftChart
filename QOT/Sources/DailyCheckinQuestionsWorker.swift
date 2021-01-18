//
//  DailyCheckinQuestionsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

let dailyCheckInIntroQuestionKey = "daily.checkin.intro"

final class DailyCheckinQuestionsWorker {

    // MARK: - Properties
    var questions: [RatingQuestionViewModel.Question]?
    weak var observer: NSObjectProtocol?

    // MARK: - Init

    init() {
    }

    func saveAnswers(_ completion: @escaping() -> Void) {
        var answers: [QDMDailyCheckInAnswer] = []

        for question in questions ?? [] {
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
                if let answers = question.answers,
                    let answerIndex = question.selectedAnswerIndex,
                    answers.count > answerIndex,
                    let count = Int(answers[answerIndex].subtitle ?? "") {
                    checkInAnswer.PeakPerformanceCount = count
                }
            }
            answers.append(checkInAnswer)
        }
        QuestionService.main.saveDailyCheckInAnswers(answers) { (error) in
            if let apiError = error {
                log("Save answer error: \(apiError)", level: .error)
            }
            completion()
        }
    }

    func checkHealthDataAndGetQuestions(_ completion: @escaping([RatingQuestionViewModel.Question]?) -> Void) {
        // check ouraRingAuthStatus
        HealthService.main.ouraRingAuthStatus { [weak self] (tracker, _) in
            if tracker != nil { // if user has ouraring
                HealthService.main.availableOuraRingDataIndexesForToday({ (indexes) in
                    if indexes?.isEmpty == false {
                        self?.getQuestions(completion)
                        return
                    }
                    requestSynchronization(.HEALTH_DATA, .DOWN_SYNC) // request oura data
                    // wait for HEALTH_DATA sync for 3.5 seconds.
                    var timer: Timer? = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { (_) in
                        self?.getQuestions(completion)
                    }

                    self?.observer = NotificationCenter.default.addObserver(forName: .didFinishSynchronization,
                                                                            object: nil,
                                                                            queue: nil) { [weak self] (notification) in
                        guard let syncResult = notification.object as? SyncResultContext,
                              syncResult.dataType == .HEALTH_DATA,
                              syncResult.syncRequestType == .DOWN_SYNC else { return }
                        timer?.invalidate()
                        timer = nil
                        self?.getQuestions(completion)
                    }
                })
            } else { // if user doesn't have Oura, keep going
                self?.getQuestions(completion)
            }
        }
    }

    func getQuestions(_ completion: @escaping([RatingQuestionViewModel.Question]?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var dailyCheckInQuestions = [QDMQuestion]()
        var hasSleepQuality = false
        var hasSleepQuantity = false

        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }

        dispatchGroup.enter()
        HealthService.main.availableHealthIndexesForToday({ (indexes) in
            for index in indexes ?? [] {
                switch index {
                case .RECOVERY_INDEX: hasSleepQuality = true
                case .SLEEP_DURATION: hasSleepQuantity = true
                }
            }
            dispatchGroup.leave()
        })

        dispatchGroup.enter()
        QuestionService.main.dailyCheckInQuestions { (questions) in
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

            let finalQuestions = dailyCheckInQuestions.filter {
                keysToFilter.contains(obj: $0.key) != true && $0.key != dailyCheckInIntroQuestionKey
            }.compactMap { (question) -> RatingQuestionViewModel.Question? in
                guard let remoteID = question.remoteID else { return nil }
                let answers = question.answers.sorted(by: { $0.sortOrder ?? 0 > $1.sortOrder ?? 0 })
                    .compactMap({ (answer) -> RatingQuestionViewModel.Answer in
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
