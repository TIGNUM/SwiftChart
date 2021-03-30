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
    func didTabNextSurvey()
    func didTabNextJourney()
    func didTabPreviousJourney()
    func didTabSkipJourney()
}

protocol GuidedStoryRouterInterface {
    func dismiss()
    func showSurvey()
    func showJourney()
}

protocol GuidedStoryDelegate: class {
    func didSelectAnswer()
    func didStartJourney()
}

protocol GuidedStorySurveyDelegate: class {
    func loadNextQuestion()
}
