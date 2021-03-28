//
//  GuidedStorySurveyPresenter.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

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
}
