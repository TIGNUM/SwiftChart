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
    var poll: QDMTeamToBeVisionPoll? { get }
    var team: QDMTeam? { get }
}
