//
//  ProfileSettingsConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ProfileSettingsConfigurator: AppStateAccess {

    static func configure(viewController: ProfileSettingsViewController) {
        guard let menuViewModel = SettingsMenuViewModel(services: appState.services),
        let settingsViewModel = SettingsViewModel(services: appState.services, settingsType: .profile) else { return }
        let worker = ProfileSettingsWorker(services: appState.services)
        let presenter = ProfileSettingsPresenter(viewController: viewController)
        let interactor = ProfileSettingsInteractor(worker: worker, presenter: presenter)
        viewController.services = appState.services
        viewController.networkManager = appState.networkManager
        viewController.launchOptions = nil
        viewController.interactor = interactor
    }
}
