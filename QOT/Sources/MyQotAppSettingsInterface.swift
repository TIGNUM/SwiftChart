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
    var appSettingsText: String { get }
}

protocol MyQotAppSettingsRouterInterface {
    func openAppSettings()
    func openCalendarSettings()
    func openActivityTrackerSettings()
    func openSiriSettings()
    func openCalendarPermission(_ type: AskPermission.Kind, delegate: AskPermissionDelegate)
}

protocol MyQotAppSettingsViewControllerInterface: class {
    func setup(_ settings: MyQotAppSettingsModel)
}
