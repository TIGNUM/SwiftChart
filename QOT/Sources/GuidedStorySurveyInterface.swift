//
//  GuidedStorySurveyInterface.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol GuidedStorySurveyViewControllerInterface: class {
    func setupView()
    func setQuestionLabel(_ question: String?)
    func setAnswers()
}

protocol GuidedStorySurveyPresenterInterface {
    func setupView()
    func setQuestion(_ question: QDMQuestion?)
}

protocol GuidedStorySurveyInteractorInterface: Interactor {
    var rowCount: Int { get }
    func title(at index: Int) -> String?
    func subtitle(at index: Int) -> String?
    func onColor(at index: Int) -> UIColor
    func didSelectAnswer(at index: Int)
    func loadNextQuestion()
}

protocol GuidedStorySurveyRouterInterface {
    func dismiss()
}
