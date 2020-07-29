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
    private var selectedTeamItem: Team.Item?

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
        presenter.present()
        worker.getTeamHeaderItems(showInvites: false) { [weak self] (teamHeaderItems) in
            self?.setFirstTeamSelected(teamHeaderItems)
            self?.teamHeaderItems = teamHeaderItems
            self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
            self?.presenter.updateView()
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
            let qotTeamId = selectedTeamItem?.teamId,
            let newName = userInfo[qotTeamId] {

            selectedTeamItem?.title = newName
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
            selectedTeamItem = header
            return
        }
    }

    func handleRemoveOrLeaveTeam() {
        worker.getTeamHeaderItems(showInvites: false) { [weak self] (teamHeaderItems) in
            self?.teamHeaderItems = teamHeaderItems
            if teamHeaderItems.isEmpty {
                self?.presenter.dismiss()
            } else {
                self?.setFirstTeamSelected(teamHeaderItems)
                self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
                self?.presenter.updateView()
            }
        }
    }

    func getTitle(for item: MyXTeamSettingsModel.Setting) -> String? {
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

    func getSubtitle(for item: MyXTeamSettingsModel.Setting) -> String? {
        switch item {
        case .leaveTeam:
            return AppTextService.get(.settings_team_settings_leave_team_subtitle)
        case .deleteTeam:
            return AppTextService.get(.settings_team_settings_delete_team_subtitle)
        default: return nil
        }
    }
}

// MARK: - MyXTeamSettingsInteractorInterface
extension MyXTeamSettingsInteractor: MyXTeamSettingsInteractorInterface {
    var rowCount: Int {
        return MyXTeamSettingsModel.Setting.items(is: canEdit).count
    }

    var canEdit: Bool {
        selectedTeamItem?.thisUserIsOwner == true
    }

    var getSelectedItem: Team.Item? {
        return selectedTeamItem
    }

    var getTeamItems: [Team.Item] {
        return teamHeaderItems
    }

    func getSelectedTeam() -> QDMTeam? {
        return selectedTeamItem?.qdmTeam
    }

    func getSettingItems() -> [MyXTeamSettingsModel.Setting] {
        return MyXTeamSettingsModel.Setting.items(is: canEdit)
    }

    func getSettingItem(at indexPath: IndexPath) -> MyXTeamSettingsModel.Setting {
        return MyXTeamSettingsModel.Setting.item(is: canEdit, at: indexPath)
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

     func getAvailableColors(_ completion: @escaping ([String]) -> Void) {
         worker.getTeamColors(completion)
     }

    func getTitleForItem(at indexPath: IndexPath) -> String {
        return getTitle(for: getSettingItems().at(index: indexPath.row) ?? .teamName) ?? ""
    }

    func getSubtitleForItem(at indexPath: IndexPath) -> String {
        return getSubtitle(for: getSettingItems().at(index: indexPath.row) ?? .teamName) ?? ""
    }

    func updateSelectedTeam(teamId: String) {
        teamHeaderItems.forEach { (item) in
            item.selected = (teamId == item.teamId)
            if item.selected {
                selectedTeamItem = item
            }
        }
        presenter.updateView()
    }

    func updateSelectedTeam(teamColor: String) {
        teamHeaderItems.filter { $0.selected }.first?.color = teamColor
        worker.updateTeamColor(teamId: getTeamId(), teamColor: teamColor)
    }

    func deleteTeam(teamItem: Team.Item) {
        worker.deleteTeam(teamItem.qdmTeam) { [weak self] (teams, _, _) in
            if teams?.isEmpty == true {
                self?.presenter.dismiss()
            } else {
                self?.handleRemoveOrLeaveTeam()
            }
        }
    }

    func leaveTeam(teamItem: Team.Item) {
        worker.leaveTeam(team: teamItem.qdmTeam) { [weak self] _ in
            self?.handleRemoveOrLeaveTeam()
        }
    }
}
