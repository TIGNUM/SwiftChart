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
    func answerStrings() -> [String]
    func answerDescriptions() -> [String]
    func selectedAnswerIndex() -> Int
    func selectionColor() -> UIColor
}

protocol QuestionnaireAnswer: class {
    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController)
    func isSelecting(answer: Any?, for questionIdentifier: Int?, from viewController: UIViewController)
    func didSelect(answer: Any?, for questionIdentifier: Int?, from viewController: UIViewController)
}
