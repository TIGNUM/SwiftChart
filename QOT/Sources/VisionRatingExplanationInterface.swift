//
//  VisionRatingExplanationInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol VisionRatingExplanationViewControllerInterface: class {
    func setupView()
}

protocol VisionRatingExplanationPresenterInterface {
    func setupView()
}

protocol VisionRatingExplanationInteractorInterface: Interactor {
    var team: QDMTeam? { get }
    func showRateScreen()
}

protocol VisionRatingExplanationRouterInterface {
    func dismiss()
    func showRateScreen(with id: Int)
}
