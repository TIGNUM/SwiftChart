//
//  GuidedStorySurveyConfigurator.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

final class GuidedStorySurveyConfigurator {
    static func make(viewController: GuidedStorySurveyViewController) {
        let presenter = GuidedStorySurveyPresenter(viewController: viewController)
        let interactor = GuidedStorySurveyInteractor(presenter: presenter)
        viewController.interactor = interactor
    }
}
