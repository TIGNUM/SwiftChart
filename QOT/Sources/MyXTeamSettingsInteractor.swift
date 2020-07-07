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
    private let worker: MyXTeamSettingsWorker
    private let presenter: MyXTeamSettingsPresenterInterface
    private var teamHeaderItems = [TeamHeader]()
    private var currentTeam: QDMTeam?

    // MARK: - Init
    init(worker: MyXTeamSettingsWorker,
         presenter: MyXTeamSettingsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.present(worker.settings())
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            teamHeaderItems.first?.selected = true
            self?.teamHeaderItems = teamHeaderItems
            self?.worker.setSelectedTeam(teamId: teamHeaderItems.first?.teamId ?? "", { [weak self] (selectedTeam) in
                self?.currentTeam = selectedTeam
                self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
                self?.presenter.updateView()
            })
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateViewData),
                                               name: .didEditTeam, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
    }

    var teamSettingsText: String {
        return worker.teamSettingsText
    }
}

// MARK: - Private
private extension MyXTeamSettingsInteractor {
    @objc func checkSelection(_ notification: Notification) {
         guard let teamId = notification.object as? String else { return }
         updateSelectedTeam(teamId: teamId)
     }

    @objc func updateViewData(_ notification: Notification) {
        guard let teamId = notification.object as? String else { return }
        updateSelectedTeam(teamId: teamId)
    }
}

// MARK: - MyXTeamSettingsInteractorInterface
extension MyXTeamSettingsInteractor: MyXTeamSettingsInteractorInterface {

    var selectedTeam: QDMTeam? {
        return self.currentTeam
    }

    func handleTap(setting: MyXTeamSettingsModel.Setting) {

    }

    func updateSelectedTeam(teamId: String) {
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            self?.teamHeaderItems = teamHeaderItems
            teamHeaderItems.forEach { (item) in
                item.selected = (teamId == item.teamId)
            }
            self?.worker.setSelectedTeam(teamId: teamId, { [weak self] (selectedTeam) in
                self?.currentTeam = selectedTeam
                self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
                self?.presenter.updateView()
            })

        }
    }

    func updateTeams() {
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            teamHeaderItems.first?.selected = true
            self?.teamHeaderItems = teamHeaderItems
            self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
            self?.presenter.updateView()
        }
    }

    func getTeamName() -> String {
        return teamHeaderItems.filter { $0.selected }.first?.title ?? ""
    }

    func deleteTeam(team: QDMTeam) {
        worker.deleteTeam(team, { teams, _, error in
            self.updateTeams()
        })
    }

    func leaveTeam(team: QDMTeam) {
        worker.leaveTeam(team: team, { _ in
            self.updateTeams()
        })
    }
}
