//
//  DailyBriefWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyBriefWorker {

    // MARK: - Properties
    var model: MyPrepsModel?
    private let questionService: qot_dal.QuestionService
    private let contentService: qot_dal.ContentService
    private let userService: qot_dal.UserService
    private let settingService: qot_dal.SettingService
    private var buckets = [QDMDailyBriefBucket]()

    // MARK: - Init
    init(questionService: qot_dal.QuestionService,
         userService: qot_dal.UserService,
         contentService: qot_dal.ContentService,
         settingService: qot_dal.SettingService) {
        self.settingService = settingService
        self.userService = userService
        self.contentService = contentService
        self.questionService = questionService
    }

    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    var rowCount: Int {
        return buckets.count
    }

    func getDailyBriefBucketsForViewModel(completion: @escaping ([QDMDailyBriefBucket]) -> Void) {
        qot_dal.DailyBriefService.main.getDailyBriefBuckets { (buckets, error) in
            if let error = error {
                qot_dal.log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
            }
            if let bucketsList = buckets {
                completion(bucketsList)
            }
        }
    }
}

// MARK: - Daily Checkin 1
extension DailyBriefWorker {

    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        questionService.question(with: 100360, in: .DailyCheckIn1) { (question) in
            guard let question = question else { return }
            let answers = question.answers.compactMap({ (qdmAnswer) -> RatingQuestionViewModel.Answer? in
                return RatingQuestionViewModel.Answer(remoteID: qdmAnswer.remoteID,
                                                      title: qdmAnswer.title,
                                                      subtitle: qdmAnswer.subtitle)
            })
            let model = RatingQuestionViewModel.Question(remoteID: question.remoteID,
                                                         title: question.title,
                                                         htmlTitle: question.htmlTitleString ?? "",
                                                         subtitle: question.subtitle,
                                                         dailyPrepTitle: "",
                                                         key: question.key ?? "",
                                                         answers: answers,
                                                         range: nil,
                                                         selectedAnswerIndex: nil)
            completion(model)
        }
    }

    func getToBeVisionImage(completion: @escaping (URL?) -> Void) {
        userService.getMyToBeVision {(vision, initialized, error) in
            if let error = error {
                qot_dal.log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
            }
            completion(vision?.profileImageResource?.url())
        }
    }

    func getReferenceValues(completion: @escaping ([String]?) -> Void) {
        var arrayOfValues: [String] = []
        settingService.getSettingsWith(keys: [.DailyCheckInFutureSleepTarget,
                                              .DailyCheckInSleepQualityTarget,
                                              .DailyCheckInLoadTarget,
                                              .DailyCheckInFutureLoadTarget]) { (settings, _, error) in
                                                if let error = error {
                                                    qot_dal.log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
                                                }
                                                settings?.forEach { (setting) in
                                                    if let longValue: Int64 = setting.value() {
                                                        arrayOfValues.append(String(longValue/60))
                                                    } else {
                                                        arrayOfValues.append(setting.textValue ?? "")
                                                    }
                                                }
                                                completion(arrayOfValues)
        }
    }

    func saveTargetValue(value: Int?) {
        settingService.getSettingsWith(keys: [.DailyCheckInFutureSleepTarget], {(settings, initialized, error) in
            if let setting = settings?.first {
                var updatedSetting = setting
                //                    turning sleep target from an answer index to a number of hours/day * 5 = 5 days sleep
                updatedSetting.longValue = (60 + (Int64(value ?? 0) * 30)) * 5
                self.settingService.updateSetting(updatedSetting, {(error) in
                    if let error = error {
                        qot_dal.log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
                    }
                })
            }
        })
    }
}

// MARK: - Daily Checkin 2
extension DailyBriefWorker {
    var shpiAnswer: QDMDailyCheckInAnswer? {
        var shpiAnswer: QDMDailyCheckInAnswer?
        buckets.forEach { (bucket) in
            bucket.dailyCheckInAnswers?.forEach({ (dailyAnswer) in
                if dailyAnswer.SHPIQuestionId != nil && dailyAnswer.answerId != nil {
                    shpiAnswer = dailyAnswer
                }
            })
        }
        return shpiAnswer
    }

    var peakPerformanceCount: Int? {
        var numberOfPeakPerformances: Int?
        buckets.forEach {(bucket) in
            bucket.dailyCheckInAnswers?.forEach({ (dailyAnswer) in
                if dailyAnswer.PeakPerformanceCount != nil && dailyAnswer.answerId != nil {
                    numberOfPeakPerformances = dailyAnswer.answerId
                }
            })
        }
        return numberOfPeakPerformances
    }

    func bucket(at row: Int) -> QDMDailyBriefBucket? {
        return buckets[row]
    }
}

// MARK: - Whats Hot
extension DailyBriefWorker {
    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void)) {
        contentService.getContentCollectionBySection(.WhatsHot, { (items) in
            completion(items?.last?.remoteID)
        })
    }

    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void)) {
        latestWhatsHotCollectionID(completion: { (collectionID) in
            self.contentService.getContentItemsByCollectionId(collectionID ?? 0, { (item) in
                completion(item?.first)
            })
        })
    }

    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void)) {
        latestWhatsHotCollectionID(completion: { (collectionID) in
            self.contentService.getContentCollectionById(collectionID ?? 0, completion)
        })
    }

    func createLatestWhatsHotModel(completion: @escaping ((WhatsHotLatestCellViewModel?)) -> Void) {
        latestWhatsHotContent(completion: { [weak self] (item) in
            self?.getContentCollection(completion: { (collection) in
                if let collection = collection {
                    completion(WhatsHotLatestCellViewModel(bucketTitle: "WHAT'S HOT",
                                                           title: collection.title,
                                                           image: URL(string: collection.thumbnailURLString ?? ""),
                                                           author: collection.author ?? "",
                                                           publisheDate: item?.createdAt ?? Date(),
                                                           timeToRead: collection.secondsRequired,
                                                           isNew: self?.isNew(collection) ?? false,
                                                           remoteID: collection.remoteID ?? 0, domainModel: nil))
                }
            })
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
        var level5Bucket = buckets.filter {$0.bucketName == .GET_TO_LEVEL_5}.first
        level5Bucket?.answerIds = [value]
        if let level5Bucket = level5Bucket {
            qot_dal.DailyBriefService.main.updateDailyBriefBucket(level5Bucket, {(error) in
                if let error = error {
                    qot_dal.log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
                }
            })
        }
    }

    var lastEstimatedLevel: Int? {
        return buckets.filter {$0.bucketName == DailyBriefBucketName.GET_TO_LEVEL_5}.first?.latestGetToLevel5Value
    }
}
