//
//  TeamToBeVisionOptionsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionOptionsInteractor: WorkerTeam {

    // MARK: - Properties
    private let presenter: TeamToBeVisionOptionsPresenterInterface!
    private var type = TeamToBeVisionOptionsModel.Types.voting
    private var model = TeamToBeVisionOptionsModel()
    var toBeVisionPoll: QDMTeamToBeVisionPoll?
    var trackerPoll: QDMTeamToBeVisionTrackerPoll?
    var team: QDMTeam?
    private var remainingDays: Int = 0

    // MARK: - Init
    init(presenter: TeamToBeVisionOptionsPresenterInterface,
         type: TeamToBeVisionOptionsModel.Types,
         trackerPoll: QDMTeamToBeVisionTrackerPoll?,
         tobeVisionPoll: QDMTeamToBeVisionPoll?,
         team: QDMTeam?) {
        self.presenter = presenter
        self.type = type
        self.toBeVisionPoll = tobeVisionPoll
        self.trackerPoll = trackerPoll
        self.team = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        var remainingDays = 0
        switch type {
        case .rating: remainingDays = 0
        case .voting: remainingDays = toBeVisionPoll?.remainingDays ?? 0
        }
        presenter.setupView(type: type,
                            headerSubtitle: getTeamTBVPollRemainingDays(remainingDays))
    }

    func viewWillAppear() {
        guard let team = team else { return }

        let dispatchGroup = DispatchGroup()
        var tmpTBVPoll: QDMTeamToBeVisionPoll?
        var tmpTrackerPoll: QDMTeamToBeVisionTrackerPoll?

        dispatchGroup.enter()
        getCurrentTeamToBeVisionPoll(for: team) { (poll) in
            tmpTBVPoll = poll
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getCurrentRatingPoll(for: team) { (poll) in
            tmpTrackerPoll = poll
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.toBeVisionPoll = tmpTBVPoll
            self?.trackerPoll = tmpTrackerPoll
            self?.presenter.reload()
        }
    }
}

// MARK: - TeamToBeVisionOptionsInteractorInterface
extension TeamToBeVisionOptionsInteractor: TeamToBeVisionOptionsInteractorInterface {
    func getTeamToBeVision(_ completion: @escaping (QDMTeamToBeVision?) -> Void) {
        guard let team = team else {
            completion(nil)
            return
        }
        getTeamToBeVision(for: team, completion)
    }

    var getType: TeamToBeVisionOptionsModel.Types {
        return type
    }

    var daysLeft: Int {
        switch type {
        case .rating: return 0
        case .voting: return toBeVisionPoll?.remainingDays ?? 0
        }
    }

    var alertCancelTitle: String {
        return AppTextService.get(.my_x_team_tbv_options_alert_leftButton)
    }

    var alertEndTitle: String {
        return AppTextService.get(.my_x_team_tbv_options_alert_rightButton)
    }

    var userDidVote: Bool {
        switch type {
        case .rating: return false//trackerPoll?.didVote ?? false
        case .voting: return toBeVisionPoll?.userDidVote ?? false
        }
    }

    func endPoll(_ completion: @escaping () -> Void) {
        switch type {
        case .rating:
            if let team = self.team {
                closeRatingPoll(for: team) {
                    completion()
                }
            }
        case .voting:
            if let poll = toBeVisionPoll {
                closeTeamToBeVisionPoll(poll) { (qdmPoll) in
                    completion()
                }
            }
        }
    }

    func showRateScreen() {
        guard let team = team else { return }
        getTeamToBeVision(for: team) { [weak self] (teamVision) in
            if let remoteId = teamVision?.remoteID {
//                self?.router.showRateScreen(with: remoteId, delegate: nil)
            }
        }
    }

    func endRating(_ completion: @escaping () -> Void) {
        guard let team = team else { return }
        closeRatingPoll(for: team, completion)
    }
}
