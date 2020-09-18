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
        presenter.setupView()
        update()
    }
}

// MARK: - Private
private extension MyXTeamSettingsInteractor {
    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            update()
            log("teamId: ⚙️⚙️⚙️" + teamId, level: .debug)
        }
        if let teamColor = userInfo[Team.KeyColor] {
            updateTeamColor(teamColor)
        }
     }

    @objc func updateViewData(_ notification: Notification) {
        guard notification.object as? String != nil else { return }
        update()
    }

    @objc func updateTeamName(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String: String],
            let qotTeamId = selectedTeamItem?.teamId,
            let newName = userInfo[qotTeamId] {

            selectedTeamItem?.title = newName
            worker.getTeamHeaderItems(showNewRedDot: false) { [weak self] (teamHeaderItems) in
                teamHeaderItems.forEach { (item) in
                    if item.teamId == qotTeamId {
                        item.title = newName
                    }
                }
                self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
                self?.presenter.updateView()
            }
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

    func setSelectedTeam(_ items: [Team.Item]) {
        selectedTeamItem = items.filter { $0.isSelected }.first
        if selectedTeamItem == nil {
            selectedTeamItem = items.first
            HorizontalHeaderView.selectedTeamId = selectedTeamItem?.teamId ?? ""
        }
    }

    func update() {
        worker.getTeamHeaderItems(showNewRedDot: false) { [weak self] (items) in
            if items.isEmpty {
                self?.presenter.dismiss()
            } else {
                self?.setSelectedTeam(items)
                self?.presenter.updateTeamHeader(teamHeaderItems: items)
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

    func viewWillAppear() {
        update()
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
        return selectedTeamItem?.title ?? ""
     }

    func getTeamId() -> String {
        return selectedTeamItem?.teamId ?? ""
     }

     func getTeamColor() -> String {
        return selectedTeamItem?.color ?? ""
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

    func updateTeamColor(_ color: String) {
        selectedTeamItem?.color = color
        worker.updateTeamColor(teamId: getTeamId(), teamColor: color)
    }

    func deleteTeam(teamItem: Team.Item) {
        worker.deleteTeam(teamItem.qdmTeam) { [weak self] (teams, _, _) in
            if teams?.isEmpty == true {
                self?.presenter.dismiss()
            } else {
                self?.update()
            }
        }
    }

    func leaveTeam(teamItem: Team.Item) {
        worker.leaveTeam(team: teamItem.qdmTeam) { [weak self] _ in
            self?.update()
        }
    }
}
