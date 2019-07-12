//
//  MyQotAppSettingsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotAppSettingsPresenterInterface {
    func present(_ settings: MyQotAppSettingsModel)
}

protocol MyQotAppSettingsInteractorInterface: Interactor {
    func handleTap(setting: MyQotAppSettingsModel.Setting)
    func appSettingsText(_ completion: @escaping(String) -> Void)
}

protocol MyQotAppSettingsRouterInterface {
    func handleTap(setting: MyQotAppSettingsModel.Setting)
}

protocol MyQotAppSettingsViewControllerInterface: class {
    func setup(_ settings: MyQotAppSettingsModel)
}
