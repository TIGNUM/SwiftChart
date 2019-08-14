//
//  QuestionnaireProtocols.swift
//  RatingAnimation
//
//  Created by Sanggeon Park on 24.10.18.
//  Copyright © 2018 Sanggeon Park. All rights reserved.
//

import UIKit

protocol Questionnaire {
    func questionIdentifier() -> Int
    func question() -> String
    func attributedQuestion() -> NSAttributedString?
    func answerStrings() -> [String]
    func answerDescriptions() -> [String]
    func selectedAnswerIndex() -> Int
    func selectionColor() -> UIColor
    func gradientTopColor() -> UIColor
    func gradientBottomColor() -> UIColor
}

protocol QuestionnaireAnswer: class {
    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController)
    func isSelecting(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController)
    func didSelect(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController)
    func saveTargetValue(value: Int?)
}

extension QuestionnaireAnswer {
    func saveTargetValue(value: Int?) {
        // Do nothing
    }
}

protocol RatingQuestionnaire {
    func getAnswers() -> [RatingQuestionViewModel.Answer]?
    func questionKey() -> String?
    func items() -> Int?
    func selectedQuestionAnswerIndex() -> Int?
    func questionIdentifier() -> Int?
    func question() -> NSAttributedString?
    func selectedAnswer() -> RatingQuestionViewModel.Answer?
}
