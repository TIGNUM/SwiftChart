//
//  ProfileSettingsProtocols.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol ProfileSettingsViewControllerInterface: class {
    func setup(profile: QDMUser)
    func presentAlert(title: String, message: String, cancelTitle: String, doneTitle: String)
}

protocol ProfileSettingsPresenterInterface {
    func loadSettingsMenu(_ profile: QDMUser)
    func presentAlert(title: String, message: String, cancelTitle: String, doneTitle: String)
}

protocol ProfileSettingsInteractorInterface: Interactor {
    func editAccountTitle(_ completion: @escaping (_ userData: String) -> Void)
    func numberOfSections() -> Int
    func generateSections()
    func numberOfItemsInSection(in section: Int) -> Int
    func row(at indexPath: IndexPath) -> SettingsRow
    func headerTitle(in section: Int) -> String
    func updateUser(_ profile: QDMUser, _ completion: @escaping () -> Void)
    func showUpdateConfirmationScreen()
    var profile: QDMUser? { get set }
}

protocol ProfileSettingsRouterInterface { }
