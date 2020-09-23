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
    private var poll: QDMTeamToBeVisionPoll?
    var team: QDMTeam?

    // MARK: - Init
    init(presenter: VisionRatingExplanationPresenterInterface,
         team: QDMTeam?,
         poll: QDMTeamToBeVisionPoll?,
         type: Explanation.Types) {
        self.presenter = presenter
        self.team = team
        self.poll = poll
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
    func startTeamTBVPoll() {

    }

    func showRateScreen() {
//        TODO
//        guard let team = team else { return }
//        worker.getTeamToBeVision(for: team) { [weak self] (teamVision) in
//            if let remoteId = teamVision?.remoteID {
//                self?.router.showRateScreen(with: remoteId)
//            }
//        }
    }
}
