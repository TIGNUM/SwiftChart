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
    func updatePageIndicator(_ page: Int)
    func setupView()
    func showJourney()
    func loadNextQuestion()
}

protocol GuidedStoryPresenterInterface {
    func updatePageIndicator(_ page: Int)
    func setupView(pageCount: Int)
    func showJourney()
    func loadNextQuestion()
}

protocol GuidedStoryInteractorInterface: Interactor {
    var currentPage: Int { get }
    var currentJourneyIndex: Int { get }
    var previousButtonJourneyIsHidden: Bool { get }
    func didTapNextSurvey()
    func didTapNextJourney()
    func didTapPreviousJourney()
    func didUpdateJourneyCurrentIndex(_ index: Int)
}

protocol GuidedStoryRouterInterface {
    func dismiss()
    func showSurvey()
    func showJourney()
}

protocol GuidedStoryDelegate: class {
    func didSelectAnswer()
    func didStartJourney()
    func didUpdateCollectionViewCurrentIndex(_ index: Int)
}

protocol GuidedStorySurveyDelegate: class {
    func loadNextQuestion()
}

protocol GuidedStoryJourneyDelegate: class {
    func scrollToItem(at index: Int)
}
