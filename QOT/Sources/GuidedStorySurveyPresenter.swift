//
//  GuidedStorySurveyPresenter.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class GuidedStorySurveyPresenter {

    // MARK: - Properties
    private weak var viewController: GuidedStorySurveyViewControllerInterface?

    // MARK: - Init
    init(viewController: GuidedStorySurveyViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - GuidedStorySurveyInterface
extension GuidedStorySurveyPresenter: GuidedStorySurveyPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func setQuestion(_ question: QDMQuestion?) {
        viewController?.setQuestionLabel(question?.title)
        viewController?.setAnswers()
    }
}
