//
//  GuidedStorySurveyInterface.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol GuidedStorySurveyViewControllerInterface: class {
    func setupView()
    func setQuestionLabel(_ question: String?)
}

protocol GuidedStorySurveyPresenterInterface {
    func setupView()
    func setQuestion(_ question: QDMQuestion?)
}

protocol GuidedStorySurveyInteractorInterface: Interactor {
    var rowCount: Int { get }
}

protocol GuidedStorySurveyRouterInterface {
    func dismiss()
}
