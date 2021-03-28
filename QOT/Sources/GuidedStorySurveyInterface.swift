//
//  GuidedStorySurveyInterface.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

protocol GuidedStorySurveyViewControllerInterface: class {
    func setupView()
}

protocol GuidedStorySurveyPresenterInterface {
    func setupView()
}

protocol GuidedStorySurveyInteractorInterface: Interactor {}

protocol GuidedStorySurveyRouterInterface {
    func dismiss()
}
