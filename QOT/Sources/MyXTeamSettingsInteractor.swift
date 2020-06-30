//
//  MyXTeamSettingsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamSettingsInteractor {

    // MARK: - Properties
    private let worker: MyXTeamSettingsWorker
    private let presenter: MyXTeamSettingsPresenterInterface

    // MARK: - Init
    init(worker: MyXTeamSettingsWorker, presenter: MyXTeamSettingsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.present(worker.settings())
    }

    var teamSettingsText: String {
        return worker.teamSettingsText
    }
}

// MARK: - MyXTeamSettingsInteractorInterface
extension MyXTeamSettingsInteractor: MyXTeamSettingsInteractorInterface {

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
}
