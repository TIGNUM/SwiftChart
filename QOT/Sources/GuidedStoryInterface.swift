//
//  GuidedStoryInterface.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

protocol GuidedStoryViewControllerInterface: class {
    func setupPageIndicator(pageCount: Int)
    func setupView()
    func showJourney()
    func loadNextQuestion()
}

protocol GuidedStoryPresenterInterface {
    func setupView(pageCount: Int)
    func showJourney()
    func loadNextQuestion()
}

protocol GuidedStoryInteractorInterface: Interactor {
    var currentPage: Int { get }
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
