//
//  GuidedStoryConfigurator.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

final class GuidedStoryConfigurator {
    static func make(viewController: GuidedStoryViewController) {
        let worker = GuidedStoryWorker()
        let presenter = GuidedStoryPresenter(viewController: viewController)
        let interactor = GuidedStoryInteractor(presenter: presenter, worker: worker)
        let router = GuidedStoryRouter(viewController: viewController, worker: worker)
        viewController.interactor = interactor
        viewController.router = router
        viewController.journeyDelegate = interactor
    }
}
