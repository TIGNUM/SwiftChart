//
//  CoachPresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachPresenter {

    // MARK: - Properties

    private weak var viewController: CoachViewControllerInterface?

    // MARK: - Init

    init(viewController: CoachViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - CoachInterface

extension CoachPresenter: CoachPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
