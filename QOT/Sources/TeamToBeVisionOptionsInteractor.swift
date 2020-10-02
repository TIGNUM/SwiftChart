//
//  TeamToBeVisionOptionsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionOptionsInteractor {

    // MARK: - Properties
    private lazy var worker = TeamToBeVisionOptionsWorker()
    private let presenter: TeamToBeVisionOptionsPresenterInterface!
    private var type = TeamToBeVisionOptionsModel.Types.voting
    private var model = TeamToBeVisionOptionsModel()
    let router: TeamToBeVisionOptionsRouter
    private var remainingDays: Int = 0
    private var team: QDMTeam?

    // MARK: - Init
    init(presenter: TeamToBeVisionOptionsPresenterInterface,
         type: TeamToBeVisionOptionsModel.Types,
         router: TeamToBeVisionOptionsRouter,
         remainingDays: Int,
         team: QDMTeam?) {
        self.presenter = presenter
        self.type = type
        self.router = router
        self.remainingDays = remainingDays
        self.team = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView(type: type, remainingDays: remainingDays)
    }
}

// MARK: - TeamToBeVisionOptionsInteractorInterface
extension TeamToBeVisionOptionsInteractor: TeamToBeVisionOptionsInteractorInterface {

    var getType: TeamToBeVisionOptionsModel.Types {
        return type
    }

    var daysLeft: Int {
        return remainingDays
    }

    func showRateScreen() {
        guard let team = team else { return }
        worker.getTeamToBeVision(for: team) { [weak self] (teamVision) in
            if let remoteId = teamVision?.remoteID {
                self?.router.showRateScreen(with: remoteId, team: team, type: .ratingOwner)
            }
        }
    }

    func endRating() {
        guard let team = team else { return }
        worker.closeRatingPoll(for: team) { [weak self] in
//            TO DO: go to Team TBVRateHistoryViewController for teams
            self?.router.dismiss()
        }
    }
}
