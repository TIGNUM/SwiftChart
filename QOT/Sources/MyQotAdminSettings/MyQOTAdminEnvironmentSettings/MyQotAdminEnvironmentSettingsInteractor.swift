//
//  MyQotAdminEnvironmentSettingsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotAdminEnvironmentSettingsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotAdminEnvironmentSettingsWorker()
    private let presenter: MyQotAdminEnvironmentSettingsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQotAdminEnvironmentSettingsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotAdminEnvironmentSettingsInterface
extension MyQotAdminEnvironmentSettingsInteractor: MyQotAdminEnvironmentSettingsInteractorInterface {
    func getHeaderTitle() -> String {
        return "ENVIRONMENT SETTINGS"
    }

    func getTitle(at index: Int) -> String {
        switch index {
        case 0:
            return "STAGING"
        default:
            return "PRODUCTION"
        }
    }

    func getIsSelected(for index: Int) -> Bool {
        let isStangingSelected = NetworkRequestManager.main.getCurrentEnvironment() == .development
        switch index {
        case 0:
            return isStangingSelected
        default:
            return !isStangingSelected
        }
     }

    func changeSelection(for index: Int) {
        NetworkRequestManager.main.switchTo(environmentType: index == 0 ? .development : .production)
        DatabaseManager.main.deleteUserRelatedData()
        NotificationCenter.default.post(name: .requestSynchronization, object: nil)
    }

    func getDatasourceCount() -> Int {
        return 2
    }
}
