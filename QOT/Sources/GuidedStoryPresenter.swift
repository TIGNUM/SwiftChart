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

    // MARK: - Init
    init(viewController: GuidedStoryViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - GuidedStoryInterface
extension GuidedStoryPresenter: GuidedStoryPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
