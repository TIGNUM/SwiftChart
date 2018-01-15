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
        let answers = Array(question.answers.sorted(by: [.sortOrder()]))
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
}

final class MorningInterviewViewModel: NSObject {

    // MARK: - Properties

    private let services: Services
    private let questionGroupID: Int
    private let validFrom: Date
    private let validTo: Date
    private let questions: [InterviewQuestion]
    private let notificationID: String
    private let guideItem: Guide.Item?

    // MARK: - Init

    init(services: Services,
         questionGroupID: Int,
         validFrom: Date,
         validTo: Date,
         notificationID: String = "",
         guideItem: Guide.Item?) {
        let questions = services.questionsService.morningInterviewQuestions(questionGroupID: questionGroupID)
        self.services = services
        self.questionGroupID = questionGroupID
        self.validFrom = validFrom
        self.validTo = validTo
        self.questions = Array(questions.flatMap(InterviewQuestion.init))
        self.notificationID = notificationID
        self.guideItem = guideItem
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
            guard let answerID = answer.remoteID.value else { return }
            let userAnswer = UserAnswer(questionID: question.remoteID,
                                        questionGroupID: self.questionGroupID,
                                        answerID: answerID,
                                        userAnswer: answer.title,
                                        validFrom: self.validFrom,
                                        validUntil: self.validTo
            )
            userAnswers.append(userAnswer)
        }
        return userAnswers
    }

    func save(userAnswers: [UserAnswer]) throws {
        let dailyPrepResults = List<IntObject>(userAnswers.map { IntObject(int: Int($0.userAnswer) ?? 0) })
        let realm = services.mainRealm
        try realm.write {
            userAnswers.forEach { (userAnswer: UserAnswer) in
                realm.add(userAnswer)
            }
            if
                let guideItem = realm.object(ofType: RealmGuideItem.self, forPrimaryKey: notificationID),
                let referencedItem = guideItem.referencedItem as? RealmGuideItemNotification {
                    referencedItem.dailyPrepResults.removeAll()
                    referencedItem.dailyPrepResults.append(objectsIn: dailyPrepResults)
            } else if let guideItemNotification = realm.syncableObject(ofType: RealmGuideItemNotification.self,
                                                                       localID: notificationID) {
                    guideItemNotification.dailyPrepResults.removeAll()
                    guideItemNotification.dailyPrepResults.append(objectsIn: dailyPrepResults)
            }
        }

        if let guideID = guideItem?.identifier {
            handleGuideItem(itemID: guideID)
        } else {
            handleGuideItem(itemID: notificationID)
        }
    }

    private func handleGuideItem(itemID: String) {
        LocalNotificationBuilder.cancelNotification(identifier: itemID)
        GuideWorker(services: services).setItemCompleted(guideID: itemID)
    }
}
