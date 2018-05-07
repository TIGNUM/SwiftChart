//
//  SettingsConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SettingsConfigurator: AppStateAccess {

    static func make() -> (SettingsViewController) -> Void {
        return { (settingsViewController) in
			let router = SettingsRouter(settingsViewController: settingsViewController, services: appState.services)
            let presenter = SettingsPresenter(viewController: settingsViewController)
			let worker = SettingsWorker(services: appState.services)
			let interactor = SettingsInteractor(worker: worker, router: router, presenter: presenter)
            settingsViewController.interactor = interactor
        }
    }
}
