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
    let router: VisionRatingExplanationRouter
    private let presenter: VisionRatingExplanationPresenterInterface!
    var team: QDMTeam?

    // MARK: - Init
    init(presenter: VisionRatingExplanationPresenterInterface, team: QDMTeam?, router: VisionRatingExplanationRouter) {
        self.presenter = presenter
        self.team = team
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - VisionRatingExplanationInteractorInterface
extension VisionRatingExplanationInteractor: VisionRatingExplanationInteractorInterface {

    func showRateScreen() {
        guard let team = team else { return }
        worker.getTeamToBeVision(for: team) { [weak self] (teamVision) in
            if let remoteId = teamVision?.remoteID {
                self?.router.showRateScreen(with: remoteId)
            }
        }
    }
}
