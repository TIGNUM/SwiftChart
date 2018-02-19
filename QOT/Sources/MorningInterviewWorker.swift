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
    private let notificationRemoteID: Int
    private let guideWorker: GuideWorker
    private let networkManager: NetworkManager

    init(services: Services,
         questionGroupID: Int,
         notificationRemoteID: Int,
         guideWorker: GuideWorker,
         networkManager: NetworkManager) {
        self.services = services
        self.questionGroupID = questionGroupID
        self.notificationRemoteID = notificationRemoteID
        self.guideWorker = guideWorker
        self.networkManager = networkManager
    }

    func questions() -> [MorningInterview.Question] {
        let realmQuestions = services.questionsService.morningInterviewQuestions(questionGroupID: questionGroupID)
        return realmQuestions.flatMap { (question) -> MorningInterview.Question? in
            guard let remoteID = question.remoteID.value else { return nil }
            // FIXME: This assumes answer title will be 1 ... 10. Use sortOrder when fixed on server
            let answers = question.answers.flatMap { (answer) -> MorningInterview.Answer? in
                guard let remoteID = answer.remoteID.value else { return nil }
                return MorningInterview.Answer(remoteID: remoteID, title: answer.title, subtitle: answer.subtitle)
                }.sorted { (a, b) -> Bool in
                    let left = Int(a.title) ?? 0
                    let right = Int(b.title) ?? 0
                    return left < right
            }
            let selectedAnswerIndex = (answers.count - 1) / 2
            return MorningInterview.Question(remoteID: remoteID,
                                             title: question.title,
                                             subtitle: question.subtitle,
                                             answers: answers,
                                             selectedAnswerIndex: selectedAnswerIndex)
        }
    }

    func saveAnswers(questions: [MorningInterview.Question]) {
        let notificationRemoteID = self.notificationRemoteID
        let notificationItem = services.guideService.notificationItem(remoteID: notificationRemoteID)
        let answers = questions.map { (question) -> UserAnswer in
            let answer = question.selectedAnswer
            return UserAnswer(questionID: question.remoteID,
                              questionGroupID: questionGroupID,
                              answerID: answer.remoteID,
                              userAnswer: answer.title,
                              notificationID: notificationRemoteID,
                              notificationIssueDate: notificationItem?.issueDate ?? Date())
        }

        let realmProvider = services.realmProvider
        do {
            let realm = try realmProvider.realm()
            try realm.write {
                realm.add(answers)

                let results = answers.map { Int($0.userAnswer) ?? 0 }
                let result = RealmInterviewResult(notificationRemoteID: notificationRemoteID, results: results)
                realm.add(result)

                // Set results on notification if it exists. Otherwise we will set it during sync
                if let notification = realm.syncableObject(ofType: RealmGuideItemNotification.self,
                                                           remoteID: notificationRemoteID) {
                    notification.interviewResult = result
                }
            }
            let guideID = GuideItemID(kind: .notification, remoteID: notificationRemoteID)
            GuideWorker(services: services).setItemCompleted(id: guideID)

            networkManager.performUserAnswerFeedbackRequest(userAnswers: answers) { (result) in
                switch result {
                case .success(let value):
                    do {
                        try realmProvider.realm().saveFeedback(value, notificationRemoteID: notificationRemoteID)
                    } catch {
                        log("Saving morning interview answers failed: \(error)", level: .error)
                    }
                case .failure(let error):
                    log("Saving morning interview answers failed: \(error)", level: .error)
                }
            }
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
