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
}

protocol GuidedStoryPresenterInterface {
    func setupView()
}

protocol GuidedStoryInteractorInterface: Interactor {
    var currentQuestionKey: String { get }
    func didTabNext()
    func didTabPrevious()
}

protocol GuidedStoryRouterInterface {
    func dismiss()
    func showSurvey()
    func showJourney()
}
