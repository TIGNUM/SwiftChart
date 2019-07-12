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
}

protocol ProfileSettingsPresenterInterface {
    func loadSettingsMenu(_ profile: QDMUser)
}

protocol ProfileSettingsInteractorInterface: Interactor {
    func editAccountTitle(_ completion: @escaping (_ userData: String) -> Void)
    func numberOfSections() -> Int
    func generateSections()
    func numberOfItemsInSection(in section: Int) -> Int
    func row(at indexPath: IndexPath) -> SettingsRow
    func headerTitle(in section: Int) -> String
    func updateUser(_ profile: QDMUser)
    var profile: QDMUser? { get set }
}
