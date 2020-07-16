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
        presenter.present(worker.settings)

        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            self?.setFirstTeamSelected(teamHeaderItems)
            self?.teamHeaderItems = teamHeaderItems
            self?.worker.setSelectedTeam(teamId: teamHeaderItems.first?.teamId ?? "") { [weak self] (selectedTeam) in
                self?.updateTeam(selectedTeam)
            }
        }
        addObservers()
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

    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateViewData),
                                               name: .didEditTeam, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeamColor,
                                               object: nil)
    }

    func updateTeam(_ selectedTeam: QDMTeam?) {
        currentTeam = selectedTeam
        presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
        presenter.updateView()
    }

    func setFirstTeamSelected(_ teamHeaderItems: [Team.Item]) {
        for header in teamHeaderItems {
            if !header.teamId.isEmpty {
                header.selected = true
                return
            }
        }
    }
}

// MARK: - MyXTeamSettingsInteractorInterface
extension MyXTeamSettingsInteractor: MyXTeamSettingsInteractorInterface {
    var selectedTeam: QDMTeam? {
        return self.currentTeam
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
            self?.setFirstTeamSelected(teamHeaderItems)
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

    func handleTap(setting: MyXTeamSettingsModel.Setting) {}
}
