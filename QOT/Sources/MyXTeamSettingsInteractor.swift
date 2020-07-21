//
//  MyXTeamSettingsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamSettingsInteractor {

    // MARK: - Properties
    private let worker = MyXTeamSettingsWorker()
    private let presenter: MyXTeamSettingsPresenterInterface
    private var teamHeaderItems = [Team.Item]()
    private var currentTeam: QDMTeam?

    var teamSettingsText: String {
        return worker.teamSettingsText
    }

    // MARK: - Init
    init(presenter: MyXTeamSettingsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        addObservers()
        presenter.present(worker.settings)
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            self?.setFirstTeamSelected(teamHeaderItems)
            self?.teamHeaderItems = teamHeaderItems
            self?.worker.setSelectedTeam(teamId: teamHeaderItems.first?.teamId ?? "") { [weak self] (selectedTeam) in
                self?.teamHeaderItems.forEach { (item) in
                    item.selected = (selectedTeam?.qotId == item.teamId)
                }
                self?.currentTeam = selectedTeam
                self?.presenter.updateTeamHeader(teamHeaderItems: self?.teamHeaderItems ?? [])
                self?.presenter.updateView()
            }
        }
    }
}

// MARK: - Private
private extension MyXTeamSettingsInteractor {
    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            updateSelectedTeam(teamId: teamId)
        }
        if let teamColor = userInfo[Team.KeyColor] {
            updateSelectedTeam(teamColor: teamColor)
        }
     }

    @objc func updateViewData(_ notification: Notification) {
        guard let teamId = notification.object as? String else { return }
        updateSelectedTeam(teamId: teamId)
    }

    @objc func updateTeamName(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String: String],
            let qotTeamId = currentTeam?.qotId,
            let newName = userInfo[qotTeamId] {
            currentTeam?.name = newName
            teamHeaderItems.forEach { (item) in
                if item.teamId == qotTeamId {
                    item.title = newName
                }
            }
            presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
            presenter.updateView()
        }
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateViewData),
                                               name: .didEditTeam, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTeamName),
                                               name: .didEditTeamName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeamColor,
                                               object: nil)
    }

    func setFirstTeamSelected(_ teamHeaderItems: [Team.Item]) {
        for header in teamHeaderItems where !header.teamId.isEmpty {
            header.selected = true
        }
    }
}

// MARK: - MyXTeamSettingsInteractorInterface
extension MyXTeamSettingsInteractor: MyXTeamSettingsInteractorInterface {
    var rowCount: Int {
        return MyXTeamSettingsModel.Setting.items(is: canEdit).count
    }

    var canEdit: Bool {
        currentTeam?.thisUserIsOwner == true
    }

    var selectedTeam: QDMTeam? {
        return currentTeam
    }

    func settingItems() -> [MyXTeamSettingsModel.Setting] {
        return MyXTeamSettingsModel.Setting.items(is: canEdit)
    }

    func settingItem(at indexPath: IndexPath) -> MyXTeamSettingsModel.Setting {
        return MyXTeamSettingsModel.Setting.item(is: canEdit, at: indexPath)
    }

    func updateSelectedTeam(teamId: String) {
        teamHeaderItems.forEach { (item) in
            item.selected = (teamId == item.teamId)
        }
        worker.setSelectedTeam(teamId: teamId) { [weak self] (selectedTeam) in
            self?.currentTeam = selectedTeam
            self?.presenter.updateTeamHeader(teamHeaderItems: self?.teamHeaderItems ?? [])
            self?.presenter.updateView()
        }
    }

    func updateSelectedTeam(teamColor: String) {
        teamHeaderItems.filter { $0.selected }.first?.color = teamColor
        presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
        presenter.updateView()
        worker.updateTeamColor(teamId: getTeamId(), teamColor: teamColor)
    }

    func updateTeams() {
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            if let teamId = self?.currentTeam?.qotId {
                self?.updateSelectedTeam(teamId: teamId)
            }
            self?.teamHeaderItems = teamHeaderItems
            self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
            self?.presenter.updateView()
        }
    }

    func getTeamName() -> String {
        return teamHeaderItems.filter { $0.selected }.first?.title ?? ""
    }

   func getTeamId() -> String {
        return teamHeaderItems.filter { $0.selected }.first?.teamId ?? ""
    }

    func getTeamColor() -> String {
        return teamHeaderItems.filter { $0.selected }.first?.color ?? ""
    }

    func getAvailableColors(_ completion: @escaping ([UIColor]) -> Void) {
        worker.getTeamColors(completion)
    }

    func deleteTeam(team: QDMTeam) {
        worker.deleteTeam(team) { teams, _, error in
            self.updateTeams()
        }
    }

    func leaveTeam(team: QDMTeam) {
        worker.leaveTeam(team: team) { _ in
            self.updateTeams()
        }
    }

    func titleForItem(at indexPath: IndexPath) -> String {
        return title(for: settingItems().at(index: indexPath.row) ?? .teamName) ?? ""
    }

    func subtitleForItem(at indexPath: IndexPath) -> String {
        return subtitle(for: settingItems().at(index: indexPath.row) ?? .teamName) ?? ""
    }

    private func title(for item: MyXTeamSettingsModel.Setting) -> String? {
        switch item {
        case .teamName:
            return ""
        case .teamMembers:
            return AppTextService.get(.settings_team_settings_team_members)
        case .leaveTeam:
            return AppTextService.get(.settings_team_settings_leave_team)
        case .deleteTeam:
            return AppTextService.get(.settings_team_settings_delete_team)
        }
    }

    private func subtitle(for item: MyXTeamSettingsModel.Setting) -> String? {
        switch item {
        case .leaveTeam:
            return AppTextService.get(.settings_team_settings_leave_team_subtitle)
        case .deleteTeam:
            return AppTextService.get(.settings_team_settings_delete_team_subtitle)
        default: return nil
        }
    }

    func handleTap(setting: MyXTeamSettingsModel.Setting) {}

}
