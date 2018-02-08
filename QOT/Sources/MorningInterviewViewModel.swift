//
//  File.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/28/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class InterviewQuestion {

    let remoteID: Int
    let title: String
    let dailyPrepTitle: String
    let subtitle: String?
    let answers: [Answer]
    var answerIndex: Int

    init?(question: Question) {
//        let answers = Array(question.answers.sorted(by: [.sortOrder(ascending: true)]))
        // FIXME: This assumes answer title will be 1 ... 10. Use sortOrder when fixed on server
        let answers = question.answers.map({ Answer(answer: $0) }).sorted { (a, b) -> Bool in
            let left = Int(a.title) ?? 0
            let right = Int(b.title) ?? 0
            return left < right
        }
        guard answers.isEmpty == false else { return nil }

        self.remoteID = question.forcedRemoteID
        self.title = question.title
        self.dailyPrepTitle = question.dailyPrepTitle
        self.subtitle = question.subtitle
        self.answers = answers
        self.answerIndex = (answers.count - 1) / 2
    }

    var currentAnswer: Answer {
        return answers[answerIndex]
    }

    struct Answer {

        let remoteID: Int?
        let title: String
        let subtitle: String?

        init(answer: QOT.Answer) {
            remoteID = answer.remoteID.value
            title = answer.title
            subtitle = answer.subtitle
        }
    }
}

final class MorningInterviewViewModel: NSObject {

    // MARK: - Properties

    private let services: Services
    private let questionGroupID: Int
    private let questions: [InterviewQuestion]
    let notificationRemoteID: Int

    // MARK: - Init

    init(services: Services,
         questionGroupID: Int,
         notificationRemoteID: Int) {
        let questions = services.questionsService.morningInterviewQuestions(questionGroupID: questionGroupID)
        self.services = services
        self.questionGroupID = questionGroupID
        self.questions = Array(questions.flatMap(InterviewQuestion.init))
        self.notificationRemoteID = notificationRemoteID
    }

    var questionsCount: Int {
        return questions.count
    }

    func question(at index: Index) -> InterviewQuestion {
        return questions[index]
    }

    func createUserAnswers() -> [UserAnswer] {
        var userAnswers = [UserAnswer]()

        questions.forEach { (question: InterviewQuestion) in
            let answer = question.currentAnswer
            guard let answerID = answer.remoteID else { return }
            let userAnswer = UserAnswer(questionID: question.remoteID,
                                        questionGroupID: self.questionGroupID,
                                        answerID: answerID,
                                        userAnswer: answer.title,
                                        notificationID: notificationRemoteID
            )
            userAnswers.append(userAnswer)
        }
        return userAnswers
    }

    func save(userAnswers: [UserAnswer]) throws {
        let realm = services.mainRealm
        try realm.write {
            // Save answers to be send to server
            userAnswers.forEach { (userAnswer: UserAnswer) in
                realm.add(userAnswer)
            }

            // Save result for guide
            let results = userAnswers.map { Int($0.userAnswer) ?? 0 }
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
    }
}
