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
    func setup()
    func updateTeamHeader(teamHeaderItems: [Team.Item])
    func updateView()
    func dismiss()
}

protocol MyXTeamSettingsPresenterInterface {
    func present()
    func updateTeamHeader(teamHeaderItems: [Team.Item])
    func updateView()
    func dismiss()
}

protocol MyXTeamSettingsInteractorInterface: Interactor {
    var teamSettingsText: String { get }
    var getSelectedItem: Team.Item? { get }
    var getTeamItems: [Team.Item] { get }
    func getSelectedTeam() -> QDMTeam?
    var canEdit: Bool { get }
    var rowCount: Int { get }

    func updateSelectedTeam(teamId: String)
    func updateSelectedTeam(teamColor: String)

    func getTeamName() -> String
    func getTeamId() -> String
    func getTeamColor() -> String
    func getAvailableColors(_ completion: @escaping ([String]) -> Void)
    func getTitleForItem(at indexPath: IndexPath) -> String
    func getSubtitleForItem(at indexPath: IndexPath) -> String
    func getSettingItems() -> [MyXTeamSettingsModel.Setting]
    func getSettingItem(at indexPath: IndexPath) -> MyXTeamSettingsModel.Setting

    func deleteTeam(teamItem: Team.Item)
    func leaveTeam(teamItem: Team.Item)
}

protocol MyXTeamSettingsRouterInterface {
    func dismiss()
    func presentTeamMembers(selectedTeamItem: Team.Item?, teamItems: [Team.Item])
    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?)
}
