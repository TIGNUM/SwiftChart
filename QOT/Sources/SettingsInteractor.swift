//
//  SettingsInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SettingsInteractor {

	let worker: SettingsWorker
    let router: SettingsRouterInterface
    let presenter: SettingsPresenterInterface

	init(worker: SettingsWorker, router: SettingsRouterInterface, presenter: SettingsPresenterInterface) {
		self.worker = worker
        self.router = router
        self.presenter = presenter
    }

    func viewDidLoad() {
        presenter.present(worker.settings())
    }
}

// MARK: - SettingsInteractor interface

extension SettingsInteractor: SettingsInteractorInterface {

    func handleTap(setting: SettingsModel.Setting) {
        router.handleTap(setting: setting)
    }
}
