//
//  TeamToBeVisionOptionsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol TeamToBeVisionOptionsViewControllerInterface: class {
    func setupView(type: TeamToBeVisionOptionsModel.Types, headerSubtitle: NSAttributedString)
}

protocol TeamToBeVisionOptionsPresenterInterface {
    func setupView(type: TeamToBeVisionOptionsModel.Types, headerSubtitle: NSAttributedString)
}

protocol TeamToBeVisionOptionsInteractorInterface: Interactor {
    var getType: TeamToBeVisionOptionsModel.Types { get }
    var daysLeft: Int { get }
    var alertCancelTitle: String { get }
    var alertEndTitle: String { get }
    var userDidVote: Bool { get }
    var toBeVisionPoll: QDMTeamToBeVisionPoll? { get }
    var trackerPoll: QDMTeamToBeVisionTrackerPoll? { get }
    var team: QDMTeam? { get }

    func endPoll(_ completion: @escaping () -> Void)
    func endRating()
    func getTeamToBeVision(_ completion: @escaping (QDMTeamToBeVision?) -> Void)
}

protocol TeamToBeVisionOptionsRouterInterface {
    func dismiss()
    func showRateScreen(with id: Int, team: QDMTeam?, type: Explanation.Types)
}
