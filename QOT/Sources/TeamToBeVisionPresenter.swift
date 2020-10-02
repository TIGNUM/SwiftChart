//
//  TeamToBeVisionPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionPresenter {

    // MARK: - Properties
    private weak var viewController: TeamToBeVisionViewControllerInterface?

    // MARK: - Init
    init(viewController: TeamToBeVisionViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - TeamToBeVisionInterface
extension TeamToBeVisionPresenter: TeamToBeVisionPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func showNullState(with title: String, teamName: String?, message: String) {
        viewController?.showNullState(with: title, teamName: teamName, message: message)
    }

    func hideNullState() {
        viewController?.hideNullState()
    }

    func load(_ teamVision: QDMTeamToBeVision?, rateText: String?, isRateEnabled: Bool) {
        viewController?.load(teamVision,
                             rateText: rateText,
                             isRateEnabled: isRateEnabled)
    }

    func hideTrends() {
        viewController?.hideTrends()
    }

    func setSelectionBarButtonItems() {
        viewController?.setSelectionBarButtonItems()
    }
}
