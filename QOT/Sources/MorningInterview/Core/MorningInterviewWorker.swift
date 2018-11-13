//
//  MorningInterviewWorker.swift
//  QOT
//
//  Created by Sam Wyndham on 19/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class MorningInterviewWorker {

    private let services: Services
    private let questionGroupID: Int
    private let date: ISODate
    private let guideWorker: GuideWorker
    private let networkManager: NetworkManager
    private let syncManager: SyncManager

    init(services: Services,
         questionGroupID: Int,
         date: ISODate,
         guideWorker: GuideWorker,
         networkManager: NetworkManager,
         syncManager: SyncManager) {
        self.services = services
        self.questionGroupID = questionGroupID
        self.date = date
        self.guideWorker = guideWorker
        self.networkManager = networkManager
        self.syncManager = syncManager
    }

    func questions() -> [MorningInterview.Question] {
        let realmQuestions = services.questionsService.morningInterviewQuestions(questionGroupID: questionGroupID)
        return realmQuestions.compactMap { (question) -> MorningInterview.Question? in
            guard let remoteID = question.remoteID.value else { return nil }
            // FIXME: This assumes answer title will be 1 ... 10. Use sortOrder when fixed on server
            let answers = question.answers.compactMap { (answer) -> MorningInterview.Answer? in
                guard let remoteID = answer.remoteID.value else { return nil }
                return MorningInterview.Answer(remoteID: remoteID, title: answer.title, subtitle: answer.subtitle)
                }.sorted { (a, b) -> Bool in
                    let left = Int(a.title) ?? 0
                    let right = Int(b.title) ?? 0
                    return left > right
            }
            let selectedAnswerIndex = (answers.count - 1) / 2
            var htmlTitleString = question.htmlTitleString
            // Apply default HTML Style
            if let htmlString = question.htmlTitleString, htmlString.count > 0 {
                htmlTitleString = R.string.localized.morningControllerQuestionHTMLStyle() + htmlString
            } else {
                htmlTitleString = nil
            }
            return MorningInterview.Question(remoteID: remoteID,
                                             title: question.title,
                                             htmlTitle: htmlTitleString,
                                             subtitle: question.subtitle,
                                             answers: answers,
                                             key: question.key,
                                             selectedAnswerIndex: selectedAnswerIndex)
        }
    }

    func saveAnswers(questions: [MorningInterview.Question]) {
        let realmProvider = services.realmProvider
        do {
            let realm = try realmProvider.realm()

            // User answers
            let userAnswers = questions.map { (question) -> UserAnswer in
                let answer = question.selectedAnswer
                return UserAnswer(questionID: question.remoteID,
                                  questionGroupID: questionGroupID,
                                  answerID: answer.remoteID,
                                  userAnswer: answer.title,
                                  date: date)
            }

            // Daily prep result
            let dailyPrepAnwsers = questions.map { (question) -> DailyPrepAnswerObject in
                let questionObject = realm.syncableObject(ofType: Question.self, remoteID: question.remoteID)
                let title = questionObject?.dailyPrepTitle ?? ""
                let value = Int(question.selectedAnswer.title) ?? 0
                return DailyPrepAnswerObject(title: title, value: value)
            }
            let title = "DAILY PREP MINUTE" // FIXME: Somehow we need to pass the NotificationConfigurationObject though
            let result = DailyPrepResultObject(date: date, title: title, answers: dailyPrepAnwsers)

            try realm.write {
                realm.add(userAnswers)
                realm.add(result)
            }
            self.syncManager.syncUserAnswers()
            self.syncManager.syncUserDependentData()
        } catch {
            log("Saving morning interview answers failed: \(error)", level: .error)
        }
    }
}

private extension Realm {

    func saveFeedback(_ feedback: UserAnswerFeedback, notificationRemoteID: Int) throws {
        try write {
            object(ofType: RealmInterviewResult.self, forPrimaryKey: notificationRemoteID)?.feedback = feedback.body
        }
    }
}
