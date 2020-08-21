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

    func showNullState(with title: String, message: String, writeMessage: String) {
        viewController?.showNullState(with: title, message: message, writeMessage: writeMessage)
    }

    func hideNullState() {
        viewController?.hideNullState()
    }

    func load(_ teamVision: QDMTeamToBeVision?, rateText: String?, isRateEnabled: Bool, shouldShowSingleMessageRating: Bool?) {
        viewController?.load(teamVision,
                             rateText: rateText,
                             isRateEnabled: isRateEnabled,
                             shouldShowSingleMessageRating: shouldShowSingleMessageRating)
    }

    func setSelectionBarButtonItems() {
        viewController?.setSelectionBarButtonItems()
    }
}
