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
    private var type: TeamAdmin.Types = .voting
    internal var toBeVisionPoll: QDMTeamToBeVisionPoll?
    internal var trackerPoll: QDMTeamToBeVisionTrackerPoll?
    internal var team: QDMTeam?

    private lazy var remainingDays: Int = {
        switch type {
        case .rating: return trackerPoll?.remainingDays ?? 0
        case .voting: return toBeVisionPoll?.remainingDays ?? 0
        }
    }()

    // MARK: - Init
    init(presenter: TeamToBeVisionOptionsPresenterInterface,
         type: TeamAdmin.Types,
         team: QDMTeam?) {
        self.presenter = presenter
        self.type = type
        self.team = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        getPollData { [weak self] in
            guard let strongSelf = self else { return }
            let days = strongSelf.remainingDays
            strongSelf.presenter.setupView(title: strongSelf.type.pageTitle,
                                           headerSubtitle: strongSelf.getTeamTBVPollRemainingDays(days))
        }
    }

    func viewWillAppear() {
        getPollData { [weak self] in
            self?.presenter.reload()
        }
    }
}

// MARK: - Private
private extension TeamToBeVisionOptionsInteractor {
    func getPollData(_ completion: @escaping () -> Void) {
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
            completion()
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

    var getType: TeamAdmin.Types {
        return type
    }

    var daysLeft: Int {
        return remainingDays
    }

    var alertCancelTitle: String {
        return AppTextService.get(.my_x_team_tbv_options_alert_leftButton)
    }

    var alertEndTitle: String {
        return AppTextService.get(.my_x_team_tbv_options_alert_rightButton)
    }

    var userDidVote: Bool {
        switch type {
        case .rating: return trackerPoll?.didVote ?? false
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

    func endRating(_ completion: @escaping () -> Void) {
        guard let team = team else { return }
        closeRatingPoll(for: team, completion)
    }
}
