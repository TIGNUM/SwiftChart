//
//  ProfileSettingsProtocols.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol ProfileSettingsViewControllerInterface: class {
    func setup(profile: ProfileSettingsModel)
    func update(profile: ProfileSettingsModel)
    func displayImageError()
}

protocol ProfileSettingsPresenterInterface {
    func loadSettingsMenu(_ profile: ProfileSettingsModel)
    func updateSettingsMenu(_ profile: ProfileSettingsModel)
    func presentImageError(_ error: Error)
}

protocol ProfileSettingsInteractorInterface: Interactor {
    func saveSettingsMenu(_ profile: ProfileSettingsModel)
    func updateSettingsMenuImage(image: UIImage, settingsMenu: ProfileSettingsModel)
}
