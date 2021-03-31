//
//  GuidedStoryInterface.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

protocol GuidedStoryViewControllerInterface: class {
    func setupView()
    func showJourney()
    func loadNextQuestion()
}

protocol GuidedStoryPresenterInterface {
    func setupView()
    func showJourney()
    func loadNextQuestion()
}

protocol GuidedStoryInteractorInterface: Interactor {
    func didTabNext()
    func didTabPrevious()
}

protocol GuidedStoryRouterInterface {
    func dismiss()
    func showSurvey()
    func showJourney()
}

protocol GuidedStoryDelegate: class {
    func didSelectAnswer()
}

protocol GuidedStorySurveyDelegate: class {
    func loadNextQuestion()
}
