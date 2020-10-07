//
//  TeamVisionTrackerDetailsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamVisionTrackerDetailsPresenter {

    // MARK: - Properties
    private weak var viewController: TeamVisionTrackerDetailsViewControllerInterface?

    // MARK: - Init
    init(viewController: TeamVisionTrackerDetailsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - TeamVisionTrackerDetailsInterface
extension TeamVisionTrackerDetailsPresenter: TeamVisionTrackerDetailsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
