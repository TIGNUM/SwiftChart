//
//  GuidedStoryPresenter.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryPresenter {

    // MARK: - Properties
    private weak var viewController: GuidedStoryViewControllerInterface?
    private weak var surveyInterface: GudidedStorySurveyViewControllerInterface?
    private weak var journeyInterface: GuidedStoryJourneyViewControllerInterface?

    // MARK: - Init
    init(viewController: GuidedStoryViewControllerInterface?,
         surveyInterface: GudidedStorySurveyViewControllerInterface?,
         journeyInterface: GuidedStoryJourneyViewControllerInterface?) {
        self.viewController = viewController
        self.surveyInterface = surveyInterface
        self.journeyInterface = journeyInterface
    }
}

// MARK: - GuidedStoryInterface
extension GuidedStoryPresenter: GuidedStoryPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
