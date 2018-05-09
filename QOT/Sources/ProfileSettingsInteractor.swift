//
//  ProfileSettingsInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

enum ProfileField {

	case telephone
	case jobTitle
	case gender
	case birthday
	case height
	case weight
}

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

	func updateProfile(field: ProfileField, profile: ProfileSettingsModel) {
		switch field {
		case .telephone: worker.updateProfileTelephone(profile)
		case .jobTitle: worker.updateJobTitle(profile)
		case .gender: worker.updateProfileGender(profile)
		case .birthday: worker.updateProfileBirthday(profile)
		case .height: worker.updateHeight(profile)
		case .weight: worker.updateWeight(profile)
		}

		presenter.updateSettingsMenu(profile)
	}

    func updateSettingsMenuImage(image: UIImage, settingsMenu: ProfileSettingsModel) {
        do {
            let url = try worker.saveImage(image)
            worker.updateSettingsProfileImage(url)
        } catch {
            presenter.presentImageError(error)
        }
    }
}
