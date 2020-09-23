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
    func setupView(type: Explanation.Types)
    func setupLabels(title: String, text: String, videoTitle: String)
    func setupVideo(thumbNailURL: URL?, placeholder: UIImage?, videoURL: URL?, duration: String, remoteID: Int)
    func setupRightBarButtonItem(title: String, type: Explanation.Types)
}

protocol VisionRatingExplanationPresenterInterface {
    func setupView(type: Explanation.Types, videoItem: QDMContentItem?)
}

protocol VisionRatingExplanationInteractorInterface: Interactor {
    var team: QDMTeam? { get }
    func showRateScreen()
    func startTeamTBVPoll()
}

protocol VisionRatingExplanationRouterInterface {
    func dismiss()
    func showRateScreen(with id: Int)
    func showTeamTBVGenerator()
}
