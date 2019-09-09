//
//  ProfileSettingsConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ProfileSettingsConfigurator {

    static func configure(viewController: ProfileSettingsViewController) {
        let worker = ProfileSettingsWorker(contentService: qot_dal.ContentService.main)
        let presenter = ProfileSettingsPresenter(viewController: viewController)
        let router = ProfileSettingsRouter(settingsMenuViewController: viewController)
        let interactor = ProfileSettingsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.launchOptions = nil
        viewController.interactor = interactor
    }
}
