//
//  ProfileSettingsInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ProfileSettingsInteractor {

    let worker: ProfileSettingsWorker
    let presenter: ProfileSettingsPresenterInterface

    init(worker: ProfileSettingsWorker, presenter: ProfileSettingsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }

    func viewDidLoad() {
        guard let settingsMenu = worker.profile() else { return }
        presenter.loadSettingsMenu(settingsMenu)
    }
}

// MARK: - SettingsMenuInteractor Interface

extension ProfileSettingsInteractor: ProfileSettingsInteractorInterface {

    func saveSettingsMenu(_ settingsMenu: ProfileSettingsModel) {
        worker.updateSettingsProfile(settingsMenu)
    }

    func updateSettingsMenuImage(image: UIImage, settingsMenu: ProfileSettingsModel) {
        do {
            var settingsMenu = settingsMenu
            settingsMenu.imageURL = try worker.saveImage(image)
            presenter.updateSettingsMenu(settingsMenu)
        } catch {
            presenter.presentImageError(error)
        }
    }
}
