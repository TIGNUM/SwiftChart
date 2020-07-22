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
    func updateTeamHeader(teamHeaderItems: [Team.Item])
    func updateView()
    func updateSettingsModel(_ settings: MyXTeamSettingsModel)
    func dismiss()
}

protocol MyXTeamSettingsPresenterInterface {
    func present(_ settings: MyXTeamSettingsModel)
    func updateTeamHeader(teamHeaderItems: [Team.Item])
    func updateView()
    func dismiss()
}

protocol MyXTeamSettingsInteractorInterface: Interactor {
    var teamSettingsText: String { get }
    var selectedTeam: QDMTeam? { get }
    var canEdit: Bool { get }
    var rowCount: Int { get }

    func updateSelectedTeam(teamId: String)
    func updateSelectedTeam(teamColor: String)
    func updateTeams()

    func getTeamName() -> String
    func getTeamId() -> String
    func getTeamColor() -> String
    func getAvailableColors(_ completion: @escaping ([String]) -> Void)
    func getTitleForItem(at indexPath: IndexPath) -> String
    func getSubtitleForItem(at indexPath: IndexPath) -> String
    func getSettingItems() -> [MyXTeamSettingsModel.Setting]
    func getSettingItem(at indexPath: IndexPath) -> MyXTeamSettingsModel.Setting

    func deleteTeam(team: QDMTeam)
    func leaveTeam(team: QDMTeam)
    func handleTap(setting: MyXTeamSettingsModel.Setting)
}

protocol MyXTeamSettingsRouterInterface {
    func dismiss()
    func presentTeamMembers(team: QDMTeam?)
    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?)
}
