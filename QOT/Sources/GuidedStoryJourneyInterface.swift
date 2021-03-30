//
//  GuidedStoryJourneyInterface.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

protocol GuidedStoryJourneyViewControllerInterface: class {
    func setupView()
}

protocol GuidedStoryJourneyPresenterInterface {
    func setupView()
}

protocol GuidedStoryJourneyInteractorInterface: Interactor {}

protocol GuidedStoryJourneyRouterInterface {
    func dismiss()
}
