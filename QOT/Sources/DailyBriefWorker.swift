//
//  DailyBriefWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import Intents

final class DailyBriefWorker {

    // MARK: - Properties
    var model: MyPrepsModel?
    private let questionService: QuestionService
    private let userService: UserService
    private let settingService: SettingService
    private var buckets = [QDMDailyBriefBucket]()
    var questions: [RatingQuestionViewModel.Question]?

    // MARK: - Init
    init(questionService: QuestionService, userService: UserService, settingService: SettingService) {
        self.settingService = settingService
        self.userService = userService
        self.questionService = questionService
    }

    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    // Get Daily Brief bucket
    func getDailyBriefBucketsForViewModel(completion: @escaping ([QDMDailyBriefBucket]) -> Void) {
        DailyBriefService.main.getDailyBriefBuckets({ (buckets, error) in
            if let error = error {
                log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
            }
            if let bucketsList = buckets {
                completion(bucketsList)
            }
        })
    }

    func hasConnectedWearable(_ completion: @escaping (Bool) -> Void) {
        HealthService.main.ouraRingAuthStatus { (tracker, config) in
            if tracker != nil {
                completion(true)
            } else if HealthService.main.isHealthDataAvailable() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func hasSiriShortcuts(_ completion: @escaping (Bool) -> Void) {
        if #available(iOS 12.0, *) {
            INVoiceShortcutCenter.shared.getAllVoiceShortcuts { (shortcuts, error) in
                DispatchQueue.main.async {
                    completion(shortcuts?.isEmpty == false)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
}

// MARK: - Daily Checkin 1
extension DailyBriefWorker {

    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        questionService.question(with: 100360, in: .DailyCheckIn1) { (question) in
        // FIXME: need to separate question and answers from daily-check-in.
            guard let question = question else { return }
            let answers = question.answers.sorted(by: { $0.sortOrder ?? 0 > $1.sortOrder ?? 0 })
                .compactMap({ (qdmAnswer) -> RatingQuestionViewModel.Answer? in
                    return RatingQuestionViewModel.Answer(remoteID: qdmAnswer.remoteID,
                                                          title: qdmAnswer.title,
                                                          subtitle: qdmAnswer.subtitle)
                })
            self.getTargetValue { (sleepTargetValue) in
                guard let sleepTargetValue = sleepTargetValue else { return }
                let selectedAnswerIndex = question.answers.count - 1 - (sleepTargetValue - 60)/30
                let model = RatingQuestionViewModel.Question(remoteID: question.remoteID,
                                                             title: question.title,
                                                             htmlTitle: question.htmlTitleString ?? "",
                                                             subtitle: question.subtitle,
                                                             dailyPrepTitle: "",
                                                             key: question.key ?? "",
                                                             answers: answers,
                                                             range: nil,
                                                             selectedAnswerIndex: selectedAnswerIndex)
                completion(model)
            }
        }
    }

    func getToBeVisionImage(completion: @escaping (URL?) -> Void) {
        userService.getMyToBeVision {(vision, initialized, error) in
            if let error = error {
                log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
            }
            completion(vision?.profileImageResource?.url())
        }
    }

   func saveTargetValue(value: Int?) {
        settingService.getSettingsWith(keys: [.DailyCheckInFutureSleepTarget], {(settings, initialized, error) in
            if let setting = settings?.first {
                var updatedSetting = setting
                // turning sleep target from an answer index to a number of hours per day
                updatedSetting.longValue = 60 + (Int64(value ?? 0) * 30)
                self.settingService.updateSetting(updatedSetting, true, {(error) in
                    if let error = error {
                        log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
                    }
                })
            }
        })
    }

    func getTargetValue(completion: @escaping (Int?) -> Void) {
        settingService.getSettingsWith(keys: [.DailyCheckInFutureSleepTarget], {(settings, initialized, error) in
            guard let savedTarget = settings?.first?.longValue else { return }
            completion(NSNumber(value: savedTarget).intValue)
        })
    }
}

// MARK: - Daily Checkin 2
extension DailyBriefWorker {

    func bucket(at row: Int) -> QDMDailyBriefBucket? {
        return buckets[row]
    }
}

// MARK: - Whats Hot
extension DailyBriefWorker {

    func didPressGotItSprint(sprint: QDMSprint) {
        userService.markAsDoneForToday(sprint, { (sprint, error) in
            if let error = error {
                log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
            }
        })
    }

    func isNew(_ collection: QDMContentCollection) -> Bool {
        var isNewArticle = collection.viewedAt == nil
        if let firstInstallTimeStamp = self.firstInstallTimeStamp {
            isNewArticle = collection.viewedAt == nil && collection.modifiedAt ?? collection.createdAt ?? Date() > firstInstallTimeStamp
        }
        return isNewArticle
    }
}

// MARK: - Get to level 5
extension DailyBriefWorker {
    func saveAnswerValue(_ value: Int) {
        getDailyBriefBucketsForViewModel(completion: {(buckets) in
            var level5Bucket = buckets.filter {$0.bucketName == .GET_TO_LEVEL_5}.first
            level5Bucket?.currentGetToLevel5Value = value
            if let level5Bucket = level5Bucket {
                DailyBriefService.main.updateDailyBriefBucket(level5Bucket, {(error) in
                    if let error = error {
                        log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
                    }
                })
            }
        })
    }
}
