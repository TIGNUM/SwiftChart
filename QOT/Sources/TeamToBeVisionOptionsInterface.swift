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
    func setupView(title: String, headerSubtitle: NSAttributedString)
    func reload()
}

protocol TeamToBeVisionOptionsPresenterInterface {
    func setupView(title: String, headerSubtitle: NSAttributedString)
    func reload()
}

protocol TeamToBeVisionOptionsInteractorInterface: Interactor {
    var getType: TeamAdmin.Types { get }
    var daysLeft: Int { get }
    var alertCancelTitle: String { get }
    var alertEndTitle: String { get }
    var userDidVote: Bool { get }
    var toBeVisionPoll: QDMTeamToBeVisionPoll? { get }
    var trackerPoll: QDMTeamToBeVisionTrackerPoll? { get }
    var team: QDMTeam? { get }
    var showBanner: Bool? { get }

    func endPoll(_ completion: @escaping () -> Void)
    func endRating(_ completion: @escaping () -> Void)
    func getTeamToBeVision(_ completion: @escaping (QDMTeamToBeVision?) -> Void)
    func viewWillAppear()
}

protocol TeamToBeVisionOptionsRouterInterface {
    func dismiss()
    func showRateScreen(with id: Int, team: QDMTeam?, type: Explanation.Types)
}
