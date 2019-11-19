//
//  ProfileSettingsInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ProfileSettingsInteractor {

    private let worker: ProfileSettingsWorker
    private let presenter: ProfileSettingsPresenterInterface
    private let router: ProfileSettingsRouterInterface

    init(worker: ProfileSettingsWorker,
         presenter: ProfileSettingsPresenterInterface,
         router: ProfileSettingsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    func viewDidLoad() {
        worker.getData({[weak self] user in
            guard let userData = user else { return }
            self?.presenter.loadSettingsMenu(userData)
        })
    }
}

// MARK: - SettingsMenuInteractor Interface
extension ProfileSettingsInteractor: ProfileSettingsInteractorInterface {

    func showUpdateConfirmationScreen() {
        presenter.presentAlert(title: worker.confirmationAlertTitle,
                               message: worker.confirmationAlertMessage,
                               cancelTitle: worker.confirmationAlertCancel,
                               doneTitle: worker.confirmationAlertDone)
    }

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

    func updateUser(_ profile: QDMUser, _ completion: @escaping () -> Void) {
        worker.update(user: profile, completion)
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
