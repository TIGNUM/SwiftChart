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

protocol GuidedStoryInteractorInterface: Interactor {}

protocol GuidedStoryRouterInterface {
    func dismiss()
    func setViewContainer(_ container: UIView)
    func showSurvey()
    func showJourney()
    func cycleFromViewController(from old: UIViewController, to new: UIViewController)
}
