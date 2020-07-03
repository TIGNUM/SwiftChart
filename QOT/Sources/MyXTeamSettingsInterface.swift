//
//  MyXTeamSettingsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyXTeamSettingsViewControllerInterface: class {
    func setup(_ settings: MyXTeamSettingsModel)
    func updateTeamHeader(teamHeaderItems: [TeamHeader])
}

protocol MyXTeamSettingsPresenterInterface {
    func present(_ settings: MyXTeamSettingsModel)
    func updateTeamHeader(teamHeaderItems: [TeamHeader])
}

protocol MyXTeamSettingsInteractorInterface: Interactor {
    func handleTap(setting: MyXTeamSettingsModel.Setting)
    var teamSettingsText: String { get }
//    var selectedTeam: QDMTeam? { get }
    func updateSelectedTeam(teamId: String)
}

protocol MyXTeamSettingsRouterInterface {
    func dismiss()
    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?)
}
