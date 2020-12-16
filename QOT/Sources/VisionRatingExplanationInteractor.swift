//
//  VisionRatingExplanationInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class VisionRatingExplanationInteractor {

    // MARK: - Properties
    private lazy var worker = VisionRatingExplanationWorker()
    private let presenter: VisionRatingExplanationPresenterInterface!
    private weak var downSyncObserver: NSObjectProtocol?
    var type = Explanation.Types.ratingOwner
    var team: QDMTeam?

    // MARK: - Init
    init(presenter: VisionRatingExplanationPresenterInterface,
         team: QDMTeam?,
         type: Explanation.Types) {
        self.presenter = presenter
        self.team = team
        self.type = type
    }

    // MARK: - Interactor
    func viewDidLoad() {
        worker.getVideoItem(type: type) { item in
            self.presenter.setupView(type: self.type, videoItem: item)
        }
    }
}

// MARK: - VisionRatingExplanationInteractorInterface
extension VisionRatingExplanationInteractor: VisionRatingExplanationInteractorInterface {
    func startTeamTBVPoll(sendPushNotification: Bool, _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        guard let team = self.team else { return }
        getOpenTeamGeneratorPoll { [weak self] (poll) in
            if let poll = poll {
                completion(poll)
            } else if team.thisUserIsOwner {
                self?.worker.openNewTeamToBeVisionPoll(for: team,
                                                       sendPushNotification: sendPushNotification) { (poll) in
                    completion(poll)
                }
            }
        }
    }

    func startTeamTrackerPoll(sendPushNotification: Bool,
                              _ completion: @escaping (QDMTeamToBeVisionTrackerPoll?, QDMTeam?) -> Void) {
        guard let team = self.team else { return }
        getOpenTeamTrackerPoll { [weak self] (currentPoll) in
            if let currentPoll = currentPoll {
                completion(currentPoll, team)
            } else {
                self?.handleOpenNewTrackerPoll(team: team, sendPushNotification: sendPushNotification, completion)
            }
        }
    }

    func getOpenTeamGeneratorPoll(_ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        if let team = team {
            worker.getCurrentTeamToBeVisionPoll(for: team, completion)
        } else {
            completion(nil)
        }
    }

    func getOpenTeamTrackerPoll(_ completion: @escaping (QDMTeamToBeVisionTrackerPoll?) -> Void) {
        if let team = team {
            worker.getCurrentRatingPoll(for: team, completion)
        } else {
            completion(nil)
        }
    }
}

// MARK: - Private
private extension VisionRatingExplanationInteractor {
    func handleOpenNewTrackerPoll(team: QDMTeam,
                                  sendPushNotification: Bool,
                                  _ completion: @escaping (QDMTeamToBeVisionTrackerPoll?, QDMTeam?) -> Void) {
        worker.openNewTeamToBeVisionTrackerPoll(for: team, sendPushNotification: sendPushNotification) { (poll) in
            completion(poll, team)
        }
    }
}
