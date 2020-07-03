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
//    private var currentTeam: QDMTeam?

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
            self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
            self?.presenter.updateView()
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeamColor,
                                               object: nil)
    }

    var teamSettingsText: String {
        return worker.teamSettingsText
    }
}

// MARK: - Private
private extension MyXTeamSettingsInteractor {
    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[TeamHeader.Selector.teamId.rawValue] {
            updateSelectedTeam(teamId: teamId)
        }
        if let teamColor = userInfo[TeamHeader.Selector.teamColor.rawValue] {
            updateSelectedTeam(teamColor: teamColor)
        }
     }
}

// MARK: - MyXTeamSettingsInteractorInterface
extension MyXTeamSettingsInteractor: MyXTeamSettingsInteractorInterface {
//
//    var selectedTeam: QDMTeam? {
//        return self.currentTeam
//    }

    func handleTap(setting: MyXTeamSettingsModel.Setting) {
//          switch setting {
//          case .notifications:
//              router.askNotificationPermission()
//          case .permissions:
//              router.openAppSettings()
//          case .calendars:
//              handleCalendarTap()
//          case .sensors:
//              router.openActivityTrackerSettings()
//          case .siriShortcuts:
//              router.openSiriSettings()
//          }
      }

    func updateSelectedTeam(teamId: String) {
        teamHeaderItems.forEach { (item) in
            item.selected = (teamId == item.teamId)
        }
        presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
        presenter.updateView()
    }

    func updateSelectedTeam(teamColor: String) {
        teamHeaderItems.filter { $0.selected }.first?.hexColorString = teamColor
        presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
        presenter.updateView()
        worker.updateTeamColor(teamId: getTeamId(), teamColor: teamColor)
    }

    func getTeamName() -> String {
        return teamHeaderItems.filter { $0.selected }.first?.title ?? ""
    }

   func getTeamId() -> String {
        return teamHeaderItems.filter { $0.selected }.first?.teamId ?? ""
    }

    func getTeamColor() -> String {
        return teamHeaderItems.filter { $0.selected }.first?.hexColorString ?? ""
    }
}
