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
    private var type = Explanation.Types.ratingOwner
    var team: QDMTeam

    // MARK: - Init
    init(presenter: VisionRatingExplanationPresenterInterface,
         team: QDMTeam,
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
    func startTeamTBVPoll(_ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        let team = self.team
        worker.getCurrentTeamToBeVisionPoll(for: team) { [weak self] (poll) in
            if let poll = poll {
                completion(poll)
            } else {
                self?.worker.openNewTeamToBeVisionPoll(for: team) { (poll) in
                    completion(poll)
                }
            }
        }
    }

    func startTeamTrackerPoll(_ completion: @escaping (QDMTeamToBeVisionTrackerPoll?) -> Void) {
        let team = self.team
        worker.getCurrentRatingPoll(for: team) { [weak self] (poll) in
            if let poll = poll {
                completion(poll)
            } else {
                self?.worker.openNewTeamToBeVisionTrackerPoll(for: team) { (poll) in
                    completion(poll)
                }
            }
        }
    }
}
