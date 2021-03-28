//
//  GuidedStoryJourneyConfigurator.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

final class GuidedStoryJourneyConfigurator {
    static func make() -> (GuidedStoryJourneyViewController) -> Void {
        return { (viewController) in
            let presenter = GuidedStoryJourneyPresenter(viewController: viewController)
            let interactor = GuidedStoryJourneyInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
