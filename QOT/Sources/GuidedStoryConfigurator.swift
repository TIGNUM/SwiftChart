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
        let surveyViewController = R.storyboard.guidedStory.surveyViCo()
        let journeyViewController = R.storyboard.guidedStory.journeyViCo()
        let presenter = GuidedStoryPresenter(viewController: viewController,
                                             surveyInterface: surveyViewController,
                                             journeyInterface: journeyViewController)
        let interactor = GuidedStoryInteractor(presenter: presenter)
        viewController.interactor = interactor
    }
}
