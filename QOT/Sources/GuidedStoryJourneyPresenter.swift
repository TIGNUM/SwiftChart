//
//  GuidedStoryJourneyPresenter.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryJourneyPresenter {

    // MARK: - Properties
    private weak var viewController: GuidedStoryJourneyViewControllerInterface?

    // MARK: - Init
    init(viewController: GuidedStoryJourneyViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - GuidedStoryJourneyInterface
extension GuidedStoryJourneyPresenter: GuidedStoryJourneyPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
