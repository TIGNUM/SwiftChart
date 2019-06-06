//
//  ProfileSettingsInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum ProfileField {

	case telephone
	case jobTitle
    case givenName
    case familyName
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
        worker.profile({[weak self] user in
            guard let userData = user else { return }
            self?.presenter.loadSettingsMenu(userData)
        })
    }
}

// MARK: - SettingsMenuInteractor Interface

extension ProfileSettingsInteractor: ProfileSettingsInteractorInterface {

    var editAccountTitle: String {
        return worker.editAccountTitle
    }

    var profile: QDMUser? {
        get {
            return worker.profile
        }
        set {
            worker.profile = newValue
        }
    }

    func updateUser(_ profile: QDMUser) {
        worker.update(user: profile)
    }

    func numberOfSections() -> Int {
        return worker.numberOfSections()
    }

    func numberOfItemsInSection(in section: Int) -> Int {
        return worker.numberOfItemsInSection(in: section)
    }

    func row(at indexPath: IndexPath) -> SettingsRow {
        return worker.row(at: indexPath)
    }

    func generateSections() {
        worker.generateSections()
    }

    func headerTitle(in section: Int) -> String {
        return worker.headerTitle(in: section)
    }
}
