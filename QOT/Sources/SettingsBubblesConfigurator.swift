//
//  SettingsBubblesConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SettingsBubblesConfigurator: AppStateAccess {

    static func make(type: SettingsBubblesType) -> (SettingsBubblesViewController) -> Void {
        return { (settingsBubblesViewController) in
            let router = SettingsBubblesRouter(viewController: settingsBubblesViewController)
            let worker = SettingsBubblesWorker(services: appState.services, type: type)
            let presenter = SettingsBubblesPresenter(viewController: settingsBubblesViewController)
            let interactor = SettingsBubblesInteractor(worker: worker, router: router, presenter: presenter)
            settingsBubblesViewController.interactor = interactor
        }
    }
}
