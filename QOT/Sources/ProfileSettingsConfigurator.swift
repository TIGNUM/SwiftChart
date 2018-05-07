//
//  ProfileSettingsConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class ProfileSettingsConfigurator: AppStateAccess {

    static func make() -> (ProfileSettingsViewController) -> Void {
        return { (settingsMenuViewController) in
            let router = ProfileSettingsRouter(settingsMenuViewController: settingsMenuViewController)
            let worker = ProfileSettingsWorker(services: appState.services,
                                            syncManger: appState.appCoordinator.syncManager)
            let presenter = ProfileSettingsPresenter(viewController: settingsMenuViewController)
            let interactor = ProfileSettingsInteractor(worker: worker, presenter: presenter)
            settingsMenuViewController.interactor = interactor
        }
    }
}
