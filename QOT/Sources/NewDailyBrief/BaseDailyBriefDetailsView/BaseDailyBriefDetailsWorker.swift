//
//  BaseDailyBriefDetailsWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BaseDailyBriefDetailsWorker {
    let model: BaseDailyBriefViewModel

    // MARK: - Init
    init(model: BaseDailyBriefViewModel) {
        self.model = model
    }

    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        QuestionService.main.question(with: 100360, in: .DailyCheckIn1) { (question) in
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

    func getTargetValue(completion: @escaping (Int?) -> Void) {
        SettingService.main.getSettingsWith(keys: [.DailyCheckInFutureSleepTarget], {(settings, initialized, error) in
            guard let savedTarget = settings?.first?.longValue else {
                completion(270) // 270 Minutes is 4:30 hours
                return
            }
            completion(NSNumber(value: savedTarget).intValue)
        })
    }
}

// MARK: - Get to level 5
extension BaseDailyBriefDetailsWorker {
    func saveAnswerValue(_ value: Int) {
        DailyBriefService.main.getDailyBriefBuckets({ (buckets, error) in
            if let error = error {
                log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
                return
            }
            if let bucketsList = buckets?.sorted(by: { $0.sortOrder < $1.sortOrder }) {
                var level5Bucket = bucketsList.filter {$0.bucketName == .GET_TO_LEVEL_5}.first
                level5Bucket?.currentGetToLevel5Value = value
                if let level5Bucket = level5Bucket {
                    DailyBriefService.main.updateDailyBriefBucket(level5Bucket, {(error) in
                        if let error = error {
                            log("Error while trying to fetch buckets:\(error.localizedDescription)", level: .error)
                        }
                        requestSynchronization(.BUCKET_RECORD, .UP_SYNC)
                    })
                }
            }
        })
    }
}
