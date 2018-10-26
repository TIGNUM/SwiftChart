//
//  DailyInterviewQuestion.swift
//  RatingAnimation
//
//  Created by Sanggeon Park on 24.10.18.
//  Copyright © 2018 Sanggeon Park. All rights reserved.
//

import Foundation

struct MorningQuestion: Questionnaire {
    let questionID: Int
    let questionString: String
    let answers: [String]
    let descriptions: [String]
    var answerIndex: Int?
    let fillColor: UIColor

    func questionIdentifier() -> Int {
        return questionID
    }

    func question() -> String {
        return questionString
    }
    func answerStrings() -> [String] {
        return answers
    }

    func answerDescriptions() -> [String] {
        return descriptions
    }

    func selectedAnswerIndex() -> Int {
        return answerIndex ?? answers.count / 2
    }

    func selectionColor() -> UIColor {
        return fillColor
    }
}
