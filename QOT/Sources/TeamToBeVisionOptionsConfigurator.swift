//
//  TeamToBeVisionOptionsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamToBeVisionOptionsConfigurator {
    static func make(viewController: TeamToBeVisionOptionsViewController,
                     type: TeamAdmin.Types,
                     team: QDMTeam?,
                     showBanner: Bool?) {
        let presenter = TeamToBeVisionOptionsPresenter(viewController: viewController)
        let interactor = TeamToBeVisionOptionsInteractor(presenter: presenter, type: type, team: team, showBanner: showBanner)
        viewController.interactor = interactor
    }
}
