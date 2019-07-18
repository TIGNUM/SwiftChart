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
}

protocol NewQuestionnaire {
    func questionIdentifier() -> Int
    func question() -> String
    func items() -> Int
    func selectedAnswerIndex() -> Int
}
