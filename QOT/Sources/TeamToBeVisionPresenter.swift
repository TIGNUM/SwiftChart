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
        var header = AppTextService.get(.my_x_team_tbv_new_section_header_title)
        header = header.replacingOccurrences(of: "{$TEAM_NAME}", with: teamName?.uppercased() ?? "")
        viewController?.showNullState(with: title, message: message, header: header)
    }

    func hideNullState() {
        viewController?.hideNullState()
    }

    func load(_ teamVision: QDMTeamToBeVision?, rateText: String?, isRateEnabled: Bool) {
        viewController?.load(teamVision,
                             rateText: rateText,
                             isRateEnabled: isRateEnabled)
    }

    func setSelectionBarButtonItems() {
        viewController?.setSelectionBarButtonItems()
    }

    func updatePollButton(userIsAdmim: Bool, userDidVote: Bool, pollIsOpen: Bool) {
        viewController?.updatePollButton(userIsAdmim: userIsAdmim,
                                         userDidVote: userDidVote,
                                         pollIsOpen: pollIsOpen)
    }
}
