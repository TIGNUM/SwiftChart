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
    func setupLabels(title: String, text: String, videoTitle: String)
    func setupVideo(thumbNailURL: URL?, placeholder: UIImage?, videoURL: URL?, duration: String)
    func setupRightBarButtonItem(title: String, type: Explanation.Types)
}

protocol VisionRatingExplanationPresenterInterface {
    func setupView(type: Explanation.Types)
}

protocol VisionRatingExplanationInteractorInterface: Interactor {
    var team: QDMTeam? { get }
    func showRateScreen()
}

protocol VisionRatingExplanationRouterInterface {
    func dismiss()
    func showRateScreen(with id: Int)
    func showTBVGenerator()
}
