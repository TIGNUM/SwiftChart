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
    let subtitle: String?
    let answers: [Answer]

    var answerIndex: Int?

    init(question: Question) {
        remoteID = question.forcedRemoteID
        title = question.title
        subtitle = question.subtitle
        answers = Array(question.answers.sorted(by: [.sortOrder()]))
    }

    var currentAnswer: Answer? {
        guard let index = answerIndex, index >= answers.startIndex, index < answers.endIndex else {
            return nil
        }
        return answers[index]
    }
}

final class MorningInterviewViewModel: NSObject {

    // MARK: - Properties

    private let services: Services
    private let questionGroupID: Int
    private let validFrom: Date
    private let validTo: Date
    private let questions: [InterviewQuestion]

    // MARK: - Init

    init(services: Services, questionGroupID: Int, validFrom: Date, validTo: Date) {
        self.services = services
        self.questionGroupID = questionGroupID
        self.validFrom = validFrom
        self.validTo = validTo
        self.questions = Array(services.questionsService.morningInterviewQuestions(questionGroupID: questionGroupID).map(InterviewQuestion.init))
    }

    var questionsCount: Int {
        return questions.count
    }

    func question(at index: Index) -> InterviewQuestion {
        return questions[index]
    }

    var userAnswers: [UserAnswer] {
        var userAnswers = [UserAnswer]()

        questions.forEach { (question: InterviewQuestion) in
            guard let answer = question.currentAnswer, let answerID = answer.remoteID.value else {
                return
            }
            
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
    
    func save() throws {
        let realm = services.mainRealm
        try realm.write {
            userAnswers.forEach { (userAnswer: UserAnswer) in
                realm.add(userAnswer)
            }
        }
    }
}
