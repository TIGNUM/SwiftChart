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
        header = header.replacingOccurrences(of: "{$TEAM_NAME}", with: teamName?.uppercased() ?? String.empty)
        viewController?.showNullState(with: title, message: message, header: header)
    }

    func hideNullState() {
        viewController?.hideNullState()
    }

    func load(_ teamVision: QDMTeamToBeVision?) {
        viewController?.load(teamVision)
    }

    func setSelectionBarButtonItems() {
        viewController?.setSelectionBarButtonItems()
    }

    func updatePoll(visionPoll: QDMTeamToBeVisionPoll?,
                    trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                    team: QDMTeam?,
                    teamToBeVision: QDMTeamToBeVision?) {
        viewController?.updateTrackerButton(poll: ButtonTheme.Poll.rating(visionPoll: visionPoll,
                                                                          trackerPoll: trackerPoll,
                                                                          team: team,
                                                                          tbv: teamToBeVision))
        viewController?.updatePollButton(poll: ButtonTheme.Poll.generator(visionPoll: visionPoll,
                                                                          trackerPoll: trackerPoll,
                                                                          team: team,
                                                                          tbv: teamToBeVision))
    }

    func hideTrends() {
        viewController?.hideTrends()
    }

    func showTrends() {
        viewController?.showTrends()
    }

    func hideSelectionBar(_ hide: Bool) {
        viewController?.hideSelectionBar(hide)
    }

}
