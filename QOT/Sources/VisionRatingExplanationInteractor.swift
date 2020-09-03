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
    let router: VisionRatingExplanationRouter
    var team: QDMTeam?

    // MARK: - Init
    init(presenter: VisionRatingExplanationPresenterInterface,
         team: QDMTeam?,
         router: VisionRatingExplanationRouter,
         type: Explanation.Types) {
        self.presenter = presenter
        self.team = team
        self.router = router
        self.type = type
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView(type: type)
    }
}

// MARK: - VisionRatingExplanationInteractorInterface
extension VisionRatingExplanationInteractor: VisionRatingExplanationInteractorInterface {

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
